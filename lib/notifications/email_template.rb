module Notifications
  class EmailTemplate
    USER_ACCOUNT_ACTIVATION = OpenStruct.new(
      subject: 'Activate your account',
      body: %{
        <p>Welcome %s,</p>
        <p>Please activate your account by clicking this <a href="%s">link</a>
      }
    )

    USER_ACCOUNT_ACTIVATION_REMAINDER = OpenStruct.new(
      subject: 'Waiting to from you',
      body: %{
        <p>%s,</p>
        <p>We still haven't seen your account activated.</p>
      }
    )
  end
end
