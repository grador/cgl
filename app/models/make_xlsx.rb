module MakeXlsx
  require 'axlsx'

  def make_url_name(bill)
    "#{Rails.root}/public/bills/#{bill.class}_#{make_bill_number(bill)}.xlsx"
  end

  def make_file_name(bill)
    "#{bill.class}_#{make_bill_number(bill)}.xlsx"
  end

  def make_bill_number(bill)
    "#{bill.delivered}_#{bill.id}_#{bill.user_id}"
  end

  def make_waybill_docs(waybill, orders)
    return false unless make_xlsx_file(waybill, waybill.loadups.includes(:item))
    orders.each {|o| p o; return false unless make_xlsx_file(o, o.lots.includes(:item))}
    true
  end

  def make_xlsx_file(bill,slots)
    Axlsx::Package.new do |p|
      p.workbook.add_worksheet(:name => 'Накладная') do |sheet|
        defaults =  { :style => :thin, :color => '000000'}
        borders = Hash.new do |hash, key|
          hash[key] = sheet.styles.add_style :border => defaults.merge( { :edges => key.to_s.split('_').map(&:to_sym) } ), :alignment => { :horizontal=> :center }
        end
        top_row =  [0, borders[:top_left], borders[:top], borders[:top], borders[:top], borders[:top_right]]
        bottom_row = [0, borders[:top], borders[:top], borders[:top], borders[:top], borders[:top]]
        sheet.add_row ['','',"Накладная на передачу товара № #{make_bill_number(bill)}"]
        name = User.where(id: bill.user_id).pluck(:name, :address)
        sheet.add_row ['', 'Кому:', name[0][0], 'От:',FIRM_NAME]
        sheet.add_row ['','Адрес:', name[0][1]]
        sheet.add_row ['','No п/п', 'Наименование товара', 'Артикул', 'Мест', 'Итого шт.'], :style => top_row
        k,q = 0,0
        slots.each do |l|
          sheet.add_row ['',"#{k+=1}", "#{l.item.full}", "#{l.item.art}", "#{l.quantity}", "#{l.item.box * l.quantity}"], :style => top_row
          q += l.quantity
        end
        sheet.add_row ['','','ИТОГО МЕСТ:','',"#{q}",''], :style => top_row
        sheet.add_row ['','','','','',''], :style => bottom_row
        sheet.add_row ['','Принял','','Сдал']
      end
      raise unless p.serialize(make_url_name(bill))
    end
    true
  rescue
    return false
  end

end