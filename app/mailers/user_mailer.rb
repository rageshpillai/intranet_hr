class UserMailer < ActionMailer::Base
  default :from => 'intranet@joshsoftware.com',
          :reply_to => 'hr@joshsoftware.com'
 
  def invitation(sender_id, receiver_id)
    @sender = User.where(id: sender_id).first
    @receiver = User.where(id: receiver_id).first
    mail(from: @sender.email, to: @receiver.email, subject: "Invitation to join Josh Intranet")
  end

  def verification(updated_user_id)
    admin_emails = User.approved.where(role: 'Admin').all.map(&:email)
    @updated_user = User.where(id: updated_user_id).first
    hr = User.approved.where(role: 'HR').first
    receiver_emails = [admin_emails, hr.email].flatten.join(',')
    mail(to: receiver_emails , subject: "#{@updated_user.public_profile.name} Profile has been updated")
  end
  
  def leave_application(sender_email, receivers, leave_application_id)
    @user = User.find_by(email: sender_email)
    @receivers = receivers
    @leave_application = LeaveApplication.where(id: leave_application_id).first
    mail(from: @user.email, to: receivers, subject: "#{@user.name} has applied for leave")
  end

  def reject_leave(leave_application_id)
    get_leave(leave_application_id)
    mail(to: @user.email, subject: "Leave Request got rejected")
  end

  def accept_leave(leave_application_id)
    get_leave(leave_application_id)
    mail(to: @user.email, subject: "Congrats! Leave Request got accepted")
  end

  def download_notification(downloader_id, document_name)
    @downloader = User.find(downloader_id)
    @document_name = document_name
    hr = User.approved.where(role: 'HR').try(:first).try(:email) || 'hr@joshsoftware.com'
    mail(to: hr, subject: "Intranet: #{@downloader.name} has downloaded #{document_name}")
  end
  
  def birthday_wish(user_id)
    @birthday_user = User.find(user_id)
    url = @birthday_user.public_profile.image.medium.path || "#{Rails.root}/app/assets/images/default_photo.gif"
    attachments.inline['user.jpg'] = File.read(url)
    mail(to: "all@joshsoftware.com", subject: "Happy Birthday #{@birthday_user.name}")
  end

  def year_of_completion_wish(user_hash)
    @user_hash = user_hash
    mail(to: "all@joshsoftware.com", subject: "Congratulations #{@user_hash.collect{|k, v| v }.flatten.join(", ")}") 
  end

  def leaves_reminder(leaves)
    hr = User.approved.where(role: 'HR').first
    admin_emails = User.approved.where(role: 'Admin').all.map(&:email)
    @receiver_emails = [admin_emails, hr.try(:email)].flatten.join(',')
    @leaves = leaves
    mail(to: @receiver_emails, subject: "Employees on leave tomorrow.") if @leaves.present?
  end

  def new_blog_notification(params)
    body = <<-body
      #{params[:post_url]}
    body

    mail(subject: "New blog '#{params[:post_title]}' has been published", body: body,
         to: 'all@joshsoftware.com')
  end

  def new_policy_notification(policy_id)
    @policy = Policy.find(policy_id)
    mail(subject: "New policy has been added",to: 'all@joshsoftware.com' )
  end

  private

  def get_leave(id)
    @leave_application = LeaveApplication.where(id: id).first
    @user = @leave_application.user
  end
end
