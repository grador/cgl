module ControllerMacros

  def self.included(base)
    base.extend(FirstClassMacroses)
  end

  module FirstClassMacroses

    def success_test_action(act)
        it("#{act}: is response success"){ expect(response).to be_success }
        it("#{act}: is status 200"){ expect(response).to have_http_status(200) }
    end
    def failure_test_action(act)
      it("#{act}: is no find item") { expect(assigns(:item)).to be_nil }
      it("#{act}: is response failure"){ expect(response).not_to be_success }
    end
  end
end