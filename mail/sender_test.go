package mail

import (
	"testing"

	"github.com/ariefro/simple-transaction/util"
	"github.com/stretchr/testify/require"
)

func TestSendEmailWithGmail(t *testing.T) {
	if testing.Short() {
		t.Skip()
	}

	config, err := util.LoadConfig("..")
	require.NoError(t, err)

	sender := NewGmailSender(config.EmailSenderName, config.EmailSenderAddress, config.EmailSenderPassword)

	subject := "A test email"
	content := `
	<h1>Hello World</h1>
	<p>This is a test message from <a href="https://ariefro.vercel.app/">Arief Romadhon</a></p>
	`
	to := []string{"siiso.app@gmail.com"}
	attachFiles := []string{"../readme.md"}

	err = sender.SendEmail(subject, content, to, nil, nil, attachFiles)
	require.NoError(t, err)
}
