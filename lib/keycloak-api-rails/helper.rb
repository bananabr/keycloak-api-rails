module Keycloak
  class Helper
    
    CURRENT_USER_ID_KEY           = "keycloak:keycloak_id"
    CURRENT_USER_EMAIL_KEY        = "keycloak:email"
    CURRENT_USER_GIVEN_NAME_KEY   = "keycloak:given_name"
    CURRENT_USER_FAMILY_NAME_KEY  = "keycloak:family_name"
    CURRENT_USER_PREFERRED_USERNAME_KEY  = "keycloak:preferred_username"
    CURRENT_USER_LOCALE_KEY       = "keycloak:locale"
    ROLES_KEY                     = "keycloak:roles"
    QUERY_STRING_TOKEN_KEY        = "authorizationToken"

    def self.current_user_id(env)
      env[CURRENT_USER_ID_KEY]
    end

    def self.assign_current_user_id(env, token)
      env[CURRENT_USER_ID_KEY] = token["sub"]
    end

    def self.current_user_email(env)
      env[CURRENT_USER_EMAIL_KEY]
    end

    def self.assign_current_user_email(env, token)
      env[CURRENT_USER_EMAIL_KEY] = token["email"]
    end

    def self.current_user_locale(env)
      env[CURRENT_USER_LOCALE_KEY]
    end

    def self.assign_current_user_locale(env, token)
      env[CURRENT_USER_LOCALE_KEY] = token["locale"]
    end

    def self.current_user_given_name(env)
      env[CURRENT_USER_GIVEN_NAME_KEY]
    end

    def self.assign_current_user_given_name(env, token)
      env[CURRENT_USER_GIVEN_NAME_KEY] = token["given_name"]
    end

    def self.current_user_family_name(env)
      env[CURRENT_USER_FAMILY_NAME_KEY]
    end

    def self.assign_current_user_family_name(env, token)
      env[CURRENT_USER_FAMILY_NAME_KEY] = token["family_name"]
    end

    def self.current_user_preferred_username(env)
      env[CURRENT_USER_PREFERRED_USERNAME_KEY]
    end

    def self.assign_current_user_preferred_username(env, token)
      env[CURRENT_USER_PREFERRED_USERNAME_KEY] = token["preferred_username"]
    end

    def self.current_user_roles(env)
      env[ROLES_KEY]
    end

    def self.assign_realm_roles(env, token)
      env[ROLES_KEY] = token.dig("realm_access", "roles")
    end

    def self.read_token_from_query_string(uri)
      parsed_uri         = URI.parse(uri)
      query              = URI.decode_www_form(parsed_uri.query || "")
      query_string_token = query.detect { |param| param.first == QUERY_STRING_TOKEN_KEY }
      query_string_token&.second
    end

    def self.create_url_with_token(uri, token)
      uri       = URI(uri)
      params    = URI.decode_www_form(uri.query || "").reject { |query_string| query_string.first == QUERY_STRING_TOKEN_KEY }
      params    << [QUERY_STRING_TOKEN_KEY, token]
      uri.query = URI.encode_www_form(params)
      uri.to_s
    end

    def self.read_token_from_headers(headers)
      headers["HTTP_AUTHORIZATION"]&.gsub(/^Bearer /, "") || ""
    end
  end
end
