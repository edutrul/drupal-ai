# drupal-security skill — Developer Notes

## When to use this skill

Use when working with:

- Building or reviewing forms, controllers, or plugins that handle user input
- Writing database queries (SQL injection prevention)
- Rendering user-provided content in render arrays or Twig
- Implementing access control on routes or entities
- Handling file uploads
- Adding CSRF protection to custom AJAX endpoints
- Auditing code for security vulnerabilities

## Mental Model

| Threat | Source | Fix |
|---|---|---|
| SQL injection | String concatenation in queries | Use query builder or placeholders |
| XSS | `#markup` with variables | Use `#plain_text` or render elements |
| Access bypass | Missing route `_permission` | Add permission requirement |
| Access bypass | `accessCheck(FALSE)` in entity queries | Use `accessCheck(TRUE)` |
| CSRF | Custom AJAX endpoints | Validate `csrf_token` service |
| File upload risk | Extension-only checks | Validate extension + MIME type |

## Example Prompts

- Audit this Drupal form handler for XSS vulnerabilities
- How do I prevent SQL injection in a custom query?
- Add proper permission checks to a custom Drupal route
- How do I securely validate file uploads in Drupal with extension and MIME checks?
- My controller has no permission check — how do I fix it?

## Security Review Prompts

When reviewing code, ask:

1. "Where does this data come from?" (User input = untrusted)
2. "Where does this data go?" (Output = escape it)
3. "Who should access this?" (Permissions required)
4. "What if this contains malicious input?" (Validate/sanitize)

## Pre-Commit Checklist

- [ ] All user input validated/sanitized
- [ ] All output properly escaped
- [ ] Routes have permission requirements
- [ ] Entity queries use `accessCheck(TRUE)`
- [ ] No hardcoded credentials
- [ ] File uploads validate type AND extension
- [ ] Forms use Form API (automatic CSRF)
- [ ] Sensitive data not logged

## Sources

- [Security in Drupal](https://www.drupal.org/docs/security-in-drupal)
- [Writing Secure Code](https://www.drupal.org/docs/security-in-drupal/writing-secure-code-for-drupal)
- [OWASP Top 10](https://owasp.org/www-project-top-ten/)
