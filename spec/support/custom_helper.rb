module CustomHelper
  def login(member)
    post "/members/login", { name: member.name, password: member.password }
  end
end