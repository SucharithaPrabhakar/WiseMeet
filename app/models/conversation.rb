class Conversation < ActiveRecord::Base
  
  belongs_to :sender, :foreign_key => :sender_id, class_name: 'User'
  belongs_to :recipient, :foreign_key => :recipient_group_id, class_name: 'Group'
 
  has_many :messages, dependent: :destroy
 
  validates_uniqueness_of :sender_id, :scope => :recipient_id
 
  scope :involving, -> (user) do
    where("conversations.sender_id =? OR conversations.recipient_group_id =?",user.id, group.id)
  end
 
  scope :between, -> (sender_id,recipient_group_id) do
    where("(conversations.sender_id = ? AND conversations.recipient_group_id =?) OR (conversations.sender_id = ? AND conversations.recipient_group_id =?)", sender_id, recipient_group_id, recipient_group_id, sender_id)
  end

end
