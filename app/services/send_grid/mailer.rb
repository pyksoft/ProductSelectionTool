module SendGrid
  class Mailer
    SUPPORT_EMAIL = 'info@accuris-usa.com'
    REQUEST_RECOMMENDATION_TEMPLATE = '048d2500-a4e4-4a57-8a62-c8b099e0ea71'
    INQUIRE_PRODUCT_TEMPLATE = 'fb6ad921-8ffd-4826-9abc-1a5a60545059'

    def self.request_recommendation(description:, email:)
      response = HTTParty.post(
        ENV['SENDGRID_URL'], 
        :body => self.body_content(email, REQUEST_RECOMMENDATION_TEMPLATE, { ":description": [description], ":email": [email] }),
        :headers => self.header_params )

      puts response.to_yaml
    end

    def self.inquire_product(product:, items:, email:)
      response = HTTParty.post(
        ENV['SENDGRID_URL'], 
        :body => self.body_content(email, INQUIRE_PRODUCT_TEMPLATE, { ":product": [product], ":items": [items], ":email": [email] }),
        :headers => self.header_params )
    end

    def self.header_params
      { "Authorization" => "Bearer " + ENV['SENDGRID_KEY'] }
    end

    def self.body_content(email, template_id, subs)

      params = {
        "to" => SUPPORT_EMAIL,
        "subject" => "Request from a prospect",
        "text" => "----------",
        "from" => email,
        "fromname" => "PCR Taq Selector",
        "x-smtpapi" => nil
      }

      params["x-smtpapi"] = {
        "sub" => subs,
        "category" => %w( Prospects ),
        "filters" => {
          "templates" => {
            "settings" => {
              "enable" => 1,
              "template_id" => template_id
            }
          }
        }
      }.to_json

      params
    end
  end
end