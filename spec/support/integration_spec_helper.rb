module IntegrationSpecHelper
  def login_with_oauth(service = :steam)
     visit "/auth/#{service}"
  end
end