module CommentsHelper
    def can_edit_comment?(user)
    	current_user == user
    end
end
