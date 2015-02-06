module FiWareIdm
  mattr_accessor :domain
  @@domain = ENV['KEYROCK_DOMAIN'] or 'account.lab.fi-ware.org'

  mattr_accessor :subdomain
  @@subdomain = ENV['KEYROCK_SUBDOMAIN'] or 'lab.fi-ware.org'

  mattr_accessor :sender
  @@sender = ENV['KEYROCK_SENDER'] or 'no-reply@account.lab.fi-ware.org'

  mattr_accessor :name
  @@name = ENV['KEYROCK_NAME'] or "FI-LAB"

  mattr_accessor :logo
  @@logo = 'Fi-lab.png'

  mattr_accessor :bug_receivers
  @@bug_receivers = []

  mattr_accessor :allowed_email_domains
  @@allowed_email_domains = []

  mattr_accessor :forbidden_email_domains
  @@forbidden_email_domains = []

  class << self
    def setup
      yield self
    end
  end
end
