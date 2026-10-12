# Using SSH Keys

Secure Shell Protocol (SSH) is used to setup an encrypted private connection between two machines using asymmetrical cryptographic.

- Asymmetrical encryption uses two key pair (public-private key) and is needed to establish cryptographically verifiable identity.
  - It's really just like a post box.
  - Any one who knows your address can throw a message in the box (public key)
  - Only the owner can open the box to get mail inside (private key)

Git uses ssh to push code securely on to a remote machine.

## Generate Key

By default an ssh-client along side a group of tools are already installed on the machine. Otherwise look into installing [openssh](https://www.openssh.org/) by far the most widely used implementation of the ssh protocol.

```consol
ssh-keygen
```

- RSA is so not cool.
- Use [Elliptic Curve Cryptography](https://en.wikipedia.org/wiki/Elliptic-curve_cryptography) `ed25519` is recommended and is set as the default on newer version of `ssh-keygen`

For older systems use:

```console
ssh-keygen -t ed25519
```

- Leave naming the empty so that it's used as the default key `~/.ssh/id_ed25519`
- Skip the passphrase too.
  - Too much of a hassle.
  - Will need to input the passphrase each time using the key
    - But if you do pleas look into ssh-agent
    - Very much cool and recommended on untrustworthy machines
    - All machines are untrustworthy!

## Upload SSH key to the GitLab Server

Go to [https://gitlab.hs-esslingen.de/-/user_settings/ssh_keys](https://gitlab.hs-esslingen.de/-/user_settings/ssh_keys)

And click on add key.

## Test Connection

```console
ssh -T git@gitlab.hs-esslingen.de
```

- Will ask you to trust the server fingerprint by input `yes`.
- This is done just this one time.
