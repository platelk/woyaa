package domain

type Email string

// EmailCredential define the required field to log in with an email
type EmailCredential struct {
	Email Email
}
