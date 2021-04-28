# frozen_string_literal: false

#
# Copyright (C) 2021 - present Instructure, Inc.
#
# This file is part of Canvas - develop by hungnv950
#
# Canvas is free software: you can redistribute it and/or modify it under
# the terms of the GNU Affero General Public License as published by the Free
# Software Foundation, version 3 of the License.
#
# Canvas is distributed in the hope that it will be useful, but WITHOUT ANY
# WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR
# A PARTICULAR PURPOSE. See the GNU Affero General Public License for more
# details.
#
# You should have received a copy of the GNU Affero General Public License along
# with this program. If not, see <http://www.gnu.org/licenses/>.
#

require 'digest'
require 'uri'

module Services
  class VnPayPaymentService
    WEBSITE_CODE = "9OH6LVTN"
    CHECKSUM_CODE = "BFKVAFYJLCFFWQNEQDADQWEXRUZWRDHU"
    #TODO: Change host name
    RETURN_URL = "http://171.241.103.4:3000/courses/vnpay_callback"
    PAYMENT_URL = "http://sandbox.vnpayment.vn/paymentv2/vpcpay.html"

    def initialize amount, description
      @amount = amount
      @description = description
    end

    def generate_url
      inputData = {
        "vnp_Amount": @amount,
        "vnp_Command": "pay",
        "vnp_CreateDate": Time.now.strftime("%Y%m%d%H%M%S"),
        "vnp_CurrCode": "VND",
        "vnp_IpAddr": Time.now.to_i,
        "vnp_Locale": "vn",
        "vnp_OrderInfo": @description,
        "vnp_OrderType": "topup",
        "vnp_ReturnUrl": RETURN_URL,
        "vnp_TmnCode": WEBSITE_CODE,
        "vnp_TxnRef": (Time.now + 10.minutes).strftime("%Y%m%d%H%M%S"),
        "vnp_Version": "2.0.0",
      }

      query=""
      inputData.each do |key, value|
        query << URI.encode(key.to_s) + "=" +  URI.encode(value.to_s) + '&';
      end
      query = query.strip[0...-1]

      "#{PAYMENT_URL}?#{query}&vnp_SecureHashType=SHA256&vnp_SecureHash=#{vnp_SecureHash(query)}"
    end

    private

    def vnp_SecureHash data
      Digest::SHA256.hexdigest CHECKSUM_CODE + data
    end
  end
end
