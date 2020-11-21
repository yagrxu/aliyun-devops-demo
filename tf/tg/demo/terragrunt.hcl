remote_state {
  backend = "oss"
  config = {
    bucket = "yagr-intl-tf-state"
    prefix    = "tg-demo"
    region = "eu-central-1"
  }
}

skip = true