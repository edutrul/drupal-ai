# drupal-contrib-mgmt skill — Developer Notes

## When to use this skill

Use when working with:

- Updating contrib modules to new major versions
- Checking Drupal 11 compatibility of installed modules
- Finding and applying patches from the Drupal.org issue queue
- Using `mglaman/composer-drupal-lenient` for version constraint overrides
- Debugging patch application failures
- Running `upgrade_status` to scan for deprecations
- Contributing patches back to Drupal.org

## Mental Model

| Scenario | Approach |
|---|---|
| Module update | `composer require drupal/module:^X.0 --with-all-dependencies` |
| D11 compatibility | Check `.info.yml` for `core_version_requirement: ^11` |
| Patch not applying | Check if merged upstream, find updated patch |
| Version constraint | Add to `drupal-lenient` allowed-list |
| Bug with error | Search drupal.org issue queue BEFORE writing custom code |

## Example Prompts

- Research known issues and patches before upgrading the Views contrib module
- Check if a contrib module devel is Drupal 11 compatible
- Find a patch for a known bug in Paragraphs
- Create a patch for the contrib views module to print a hello message in a part of the code. 
- Set up the Drupal Lenient plugin for a module

## Sources

- [Composer Patches](https://github.com/cweagans/composer-patches)
- [Drupal Lenient](https://github.com/mglaman/composer-drupal-lenient)
- [Upgrade Status Module](https://www.drupal.org/project/upgrade_status)
- [Patch Naming Standards](https://www.drupal.org/node/1054616)
- [Creating Issue Forks](https://www.drupal.org/docs/develop/git/using-gitlab-to-contribute-to-drupal/creating-issue-forks)
- [Git Workflow for Drupal](https://www.drupal.org/docs/develop/git/using-git-to-contribute-to-drupal)
- [Text Formatting Tips](https://www.drupal.org/filter/tips)

---

## Complete Update Checklist

- [ ] Check current version: `composer show drupal/module_name`
- [ ] Search issue queue for known issues
- [ ] Check D11 compatibility (`.info.yml`)
- [ ] Add to `drupal-lenient` if needed
- [ ] Search for and apply necessary patches
- [ ] Run `composer require drupal/module_name:^X.0 --with-all-dependencies`
- [ ] Run `drush updb -y && drush cr`
- [ ] Run `drush upgrade_status:analyze module_name`
- [ ] Test module functionality by visiting relevant pages
- [ ] Check for PHP errors: `ddev drush ws --severity=error`
- [ ] Commit changes with descriptive message

## Production Deployment

```bash
# CRITICAL: Always use these flags for production
composer install --no-dev -o
# --no-dev: Excludes dev dependencies (phpunit, rector, etc.)
# -o: Optimizes autoloader for performance
```

Never commit vendor/ with dev dependencies to production branches.

## Developing Contrib Modules Locally (Symlink Workflow)

```bash
# 1. Clone module to temp location
cd /tmp && git clone git@git.drupal.org:project/module_name.git

# 2. Remove composer version and symlink
rm -rf docroot/modules/contrib/module_name
ln -s /tmp/module_name docroot/modules/contrib/module_name

# 3. Develop and test, then when done:
rm docroot/modules/contrib/module_name
composer install  # Reinstalls from drupal.org
```

Remember: remove symlink before committing project changes.

## Contributing Back to drupal.org

### Issue Fork Workflow

```bash
# Clone the module repo
cd ~/Sites && git clone git@git.drupal.org:project/module_name.git module_name-contrib
cd module_name-contrib

# Add issue fork remote (XXXXXXX = issue number)
git remote add module_name-XXXXXXX git@git.drupal.org:issue/module_name-XXXXXXX.git
git fetch module_name-XXXXXXX
git checkout -b 'XXXXXXX-short-description' --track module_name-XXXXXXX/'XXXXXXX-short-description'

# Make changes, then commit
git commit -m "Issue #XXXXXXX: Short description"
git push module_name-XXXXXXX XXXXXXX-short-description
```

After push, a URL appears to create a merge request. Set issue status to "Needs review".

### Commit Message Format

```
Issue #XXXXXXX: Short description (50 chars max)

- Detail about what changed
- Technical implementation note
```

### Using Remote Patch After MR Created

```json
{
  "patches": {
    "drupal/module_name": {
      "Feature (https://www.drupal.org/project/module_name/issues/XXXXXXX)": "https://git.drupalcode.org/project/module_name/-/merge_requests/XXX.diff"
    }
  }
}
```

### Issue Description Format (drupal.org HTML)

```html
<h3 id="overview">Overview</h3>
<p>Problem description here.</p>

<h3 id="proposed-resolution">Proposed resolution</h3>
<p><strong>Technical implementation:</strong></p>
<ul><li><code>SomeClass</code> - description</li></ul>

<h3 id="steps-to-test">Steps to test</h3>
<ol><li>First step</li><li>Expected result</li></ol>
```

## D11 Deprecation Fix Examples

**Replace `REQUEST_TIME`:**
```php
use Drupal\Core\Datetime\TimeInterface;
// Inject 'datetime.time' service, then:
$timestamp = $this->time->getRequestTime();
```

**Replace `user_roles()`:**
```php
use Drupal\user\Entity\Role;
$roles = Role::loadMultiple();
// Filter out 'anonymous' if needed
```

**Create `.info.yml` patch for D11 support:**
```diff
-core_version_requirement: ^9 || ^10
+core_version_requirement: ^9 || ^10 || ^11
```
