---
layout: post
title: "🔒 Application Security"
date: 2020-03-14
---

Some notes about application security for `Rails` application.

What to think about when your application runs in production, things to keep in mind to prevent data leak.

## Checklist

- [ ] No usage of `.html_safe` anywhere in the code. The app uses safe view helpers such as `safe_join`, `content_tag`, etc. to render html.
- [ ] Use `protect_from_forgery with: :exception` in `ApplicationController`.
- [ ] No reference to `skip_before_action :verify_authenticity_token` or `protect_from_forgery except:` anywhere.
- [ ] All references to `javascript_include_tag` include the `integrity: true` argument ([more on SRI](https://githubengineering.com/subresource-integrity/)). You'll also need to use `crossorigin: 'anonymous'` for resources fetched from our CDN.
- [ ] `config.force_ssl = true` is present in `config/application.rb` or `config/environments/production.rb`.
- [ ] The session cookie has both the `secure` and `httpOnly` flag (usually provided by `force_ssl` above)
- [ ] The application is serving the following HTTP headers (verify names and values) [secure headers configuration](https://github.com/twitter/secureheaders#configuration)
  - [ ] `X-Frame-Options: DENY`
  - [ ] `X-Content-Type-Options: nosniff`
  - [ ] `X-Download-Options: noopen`
  - [ ] `X-Permitted-Cross-Domain-Policies: none`
  - [ ] `X-Xss-Protection: 1; mode=block`
  - [ ] `Referrer-Policy: origin-when-cross-origin` \*
  - [ ] `Content-Security-Policy: block-all-mixed-content;` or `Content-Security-Policy: upgrade-insecure-requests;`
  - [ ] `Strict-Transport-Security: max-age=631138519; includeSubdomains` (`includeSubdomains` is optional, `max-age` should be at least 10 years)
- [ ] Rails log scrubber is configured with sensitive parameter names:
  - `config.filter_parameters += [:password]`
  - `config.filter_parameters += [:access_token]`
  - `config.filter_parameters += [:secret]`
  - Any other sensitive params.
- [ ] `config.session_store` is configured with redis or mysql (usually in `config/initializers/session_store.rb`)

### Links

- [Ankane blog post](https://ankane.org/sensitive-data-rails)
- [Secure Rails gem](https://github.com/ankane/secure_rails)
- [Share private note](https://privnote.com)
- [Share private secret](https://yopass.se)
- [Best practice](https://12factor.net/)

If you are curious to learn more about security, I suggest you to read about the [OSWAP](https://owasp.org/www-project-top-ten/).
