module FiWareIdm
  module Models
    module User
      extend ActiveSupport::Concern

      included do
        # Overwrite User#represented method
        #
        # Right now, we do not need confirmation from users to represent
        def represented
          contact_subjects(direction: :received) do |q|
            q.joins(sent_ties: { relation: :permissions }).
              merge(Permission.represent)
          end
        end

        alias_method_chain :as_json, :organizations
      end

      # Authorize FiWARE apps by default
      def client_authorized?(app)
        app.official? || super
      end

      # Overwrite application role information in JSON
      def as_json_with_organizations options = {}
        hash = as_json_without_organizations options

        ties = ties_from_organizations(options[:client])

        return hash if ties.blank?

        hash['organizations'] = []

        # Maps ties_from_organizations into a hash of organization and roles
        #   {
        #     organization1: [ role1, role2 ],
        #     organization2: [ role3 ]
        #   }
        ties_hash = ties.inject({}) do |hash, tie|
          hash[tie.sender] ||= []
          hash[tie.sender] << tie.relation
          hash
        end

        ties_hash.each_pair do |org, roles|
          hash['organizations'] << {
            id: org.subject.id,
            actorId: org.id,
            displayName: org.name,
            roles: roles.map{ |r|
              {
                id: r.id,
                name: r.name
              }
            }
          }
        end

        hash
      end

      # Grab all the ties sent by organizations received by this user
      def ties_from_organizations(application)
        return if application.blank? ||
          (role_ids = application.custom_roles.map(&:id)).blank?

        ::Tie.
          joins(sender: :group).
          includes({ sender: :group }, :relation).
          merge(Group.where(type: 'Organization')).
          merge(::Relation.where(id: role_ids)).
          received_by(self)
      end
    end
  end
end