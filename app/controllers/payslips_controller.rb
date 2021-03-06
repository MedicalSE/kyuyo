class PayslipsController < ApplicationController

  def pdf
    @payslip = Payslip.find(params[:id])

    send_data @payslip.to_pdf, filename: "payslip_#{@payslip.id}",
      type: 'application/pdf', disposition: 'attachment'
  end

  # GET /payslips/new
  # GET /payslips/new.json
  def new
    @payslip = Payslip.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @payslip }
    end
  end

  # POST /payslips
  def create
    #保存はしないのでmassasign protectionをoffにする
    @payslip = Payslip.new((params[:payslip] || JSON.parse(params[:payslip_obj])), :without_protection => true)

    respond_to do |format|
      if @payslip.valid?
        send_data @payslip.to_pdf, filename: "payslip_#{@payslip.name}_#{@payslip.payslip_date.strftime('%Y_%m')}",
          type: 'application/pdf', disposition: 'attachment'
        return
      else
        format.html { render action: "new" }
      end
    end
  end

  def import
    @payslips = Payslip.import(params[:file])

    respond_to do |format|
      format.html
      format.js
    end
  end
end
