# LintPal rules

A small, versioned catalog of reusable [LintPal](https://github.com/diffpal/lintpal) review mandates. Each Markdown file contains one narrow requirement and explicit severity and decision threshold policy.

## Import rules

Pin imports to a release tag so that rule changes arrive through an explicit dependency update:

```bash
lintpal rule import github:diffpal/lintpal-rules//general@v1.0.0
lintpal rule import github:diffpal/lintpal-rules//go@v1.0.0
lintpal rule validate
```

Use a prefix when a project already has rules with the same IDs:

```bash
lintpal rule import github:diffpal/lintpal-rules//go@v1.0.0 --prefix upstream
```

Imported rules are copied into `.lintpal/rules/`. Review and commit them with the project. LintPal resolves the tag to a commit during import; lint runs use the committed local copies.

## Catalog

### General

- `authorization.md` requires resource and action authorization.
- `input-validation.md` requires constraints on untrusted input.
- `secret-handling.md` prevents secret disclosure and unsafe storage.

### Go

- `checked-errors.md` requires meaningful errors to be handled or returned.
- `context-propagation.md` preserves request cancellation and deadlines.
- `goroutine-lifecycle.md` requires a bounded goroutine lifetime.

## Validate changes

Install LintPal 0.4.0 or newer, then run:

```bash
./scripts/validate.sh
```

The script imports each catalog independently, validates the combined catalog, and confirms malformed rule metadata is rejected.

## License

MIT. See [LICENSE](LICENSE).
