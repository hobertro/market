module RelationshipsHelper
  def blocked_relationships?
    id = params[:user_id] || params[:id]
    if Relationship.get_all_block_or_blocking_users(current_user.id).include?(id.to_i)
      redirect_to root_path
    end
  end
end
