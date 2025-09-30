<html lang="en">
<head>
  <meta charset="utf-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1" />
  
</head>
<body>
  <h1>Task 6 Password Strength Evaluation</h1>

  <h3>Summary</h3>
  <p class="muted">Objective: create multiple passwords, evaluate strength using local tools and an online meter, and summarise best practices.</p>

  <h3>Files in this repo</h3>
  <table>
    <thead>
      <tr><th>No</th><th>File</th><th>Description</th></tr>
    </thead>
    <tbody>
      <tr><td>1</td><td>passwords_plain.txt</td><td>Example passwords (redacted for safety)</td></tr>
      <tr><td>2</td><td>pwgen_generated.txt</td><td>Generated password examples</td></tr>
      <tr><td>3</td><td>passwd_shadow.txt</td><td>Shadow-style hashes for local cracking demo</td></tr>
      <tr><td>4</td><td>hashes_sha256.txt</td><td>SHA256 hashes in John format</td></tr>
      <tr><td>5</td><td>screenshots/</td><td>Tool and meter screenshots</td></tr>
      <tr><td>6</td><td>README.md</td><td>This document</td></tr>
    </tbody>
  </table>

  <h3>Passwords tested (redacted)</h3>
  <table>
    <thead>
      <tr><th>#</th><th>Example (redacted)</th><th>Local tool (cracklib)</th><th>John result</th></tr>
    </thead>
    <tbody>
      <tr><td>1</td><td>pass***</td><td>FAILED / weak</td><td>cracked</td></tr>
      <tr><td>2</td><td>hello***</td><td>FAILED / weak</td><td>cracked</td></tr>
      <tr><td>3</td><td>Fateh@2025</td><td>OK / moderate</td><td>not cracked</td></tr>
      <tr><td>4</td><td>Linux#Power9</td><td>OK / moderate</td><td>not cracked</td></tr>
      <tr><td>5</td><td>Mokanojiya@...#</td><td>OK / strong</td><td>not cracked</td></tr>
    </tbody>
  </table>

  <h3>Tools used</h3>
  <table>
    <thead>
      <tr><th>Tool</th><th>Purpose</th></tr>
    </thead>
    <tbody>
      <tr><td>cracklib-check</td><td>Dictionary and rule-based checks</td></tr>
      <tr><td>john</td><td>Offline cracking with wordlists and rules</td></tr>
      <tr><td>pwgen</td><td>Generate test passwords</td></tr>
      <tr><td>openssl</td><td>Hashing (SHA256 shown in repo)</td></tr>
      <tr><td>scrot / gnome-screenshot</td><td>Capture tool outputs</td></tr>
      <tr><td>passwordmeter.com</td><td>Online strength meter (screenshots)</td></tr>
    </tbody>
  </table>

  <h3>Key findings</h3>
  <table>
    <thead>
      <tr><th>No</th><th>Finding</th></tr>
    </thead>
    <tbody>
      <tr><td>1</td><td>Length and entropy matter most; aim for 12+ characters or use passphrases</td></tr>
      <tr><td>2</td><td>Dictionary words and common substitutions are still crackable when short</td></tr>
      <tr><td>3</td><td>Passwords that appear in common lists (e.g. rockyou) are quickly cracked</td></tr>
      <tr><td>4</td><td>Use passphrases or long generated strings and a password manager</td></tr>
    </tbody>
  </table>

  <h3>Best practices</h3>
  <table>
    <thead>
      <tr><th>No</th><th>Practice</th></tr>
    </thead>
    <tbody>
      <tr><td>I</td><td>Use 12–16+ characters (longer when possible)</td></tr>
      <tr><td>II</td><td>Mix uppercase, lowercase, numbers, and symbols</td></tr>
      <tr><td>III</td><td>Avoid single dictionary words and predictable substitutions</td></tr>
      <tr><td>IV</td><td>Use unique passwords for each account</td></tr>
      <tr><td>V</td><td>Enable multi-factor authentication where possible</td></tr>
      <tr><td>VI</td><td>Use a reputable password manager (KeePassXC, Bitwarden, etc.)</td></tr>
    </tbody>
  </table>

  <h3>Common attacks (short)</h3>
  <table>
    <thead>
      <tr><th>No</th><th>Attack</th></tr>
    </thead>
    <tbody>
      <tr><td>1</td><td>Brute force — tries all combinations; length increases time exponentially</td></tr>
      <tr><td>2</td><td>Dictionary attack — uses precompiled lists of likely passwords</td></tr>
      <tr><td>3</td><td>Phishing / social engineering — tricks users into revealing credentials</td></tr>
      <tr><td>4</td><td>Credential stuffing — reusing breached credentials across sites</td></tr>
    </tbody>
  </table>

  <h3>How to reproduce locally (commands)</h3>
  <pre>
# generate example passwords
pwgen -s 12 10

# check passwords with cracklib
printf "%s\n" password1 | cracklib-check

# create sha256 hashes in john format
grep -v '^#' passwords_plain.txt | nl -ba | while read -r i pw; do
  h=$(printf "%s" "$pw" | openssl dgst -sha256 -binary | xxd -p -c 256 | tr -d '\n')
  echo "user$i:$h" >> hashes_sha256.txt
done

# run john against sha512crypt style shadow file
john --wordlist=/usr/share/wordlists/rockyou.txt passwd_shadow.txt
  </pre>

  <h3>Design steps</h3>
  <table>
    <thead><tr><th>No</th><th>Step</th></tr></thead>
    <tbody>
      <tr><td>1</td><td>🔒 prepare environment install tools</td></tr>
      <tr><td>2</td><td>🧪 generate test passwords using pwgen and samples</td></tr>
      <tr><td>3</td><td>🧾 evaluate with cracklib john and online meter take screenshots</td></tr>
      <tr><td>4</td><td>✅ analyze results summarize best practices</td></tr>
      <tr><td>5</td><td>📁 store artifacts hashes and redacted examples</td></tr>
    </tbody>
  </table>

  <h3>Notes</h3>
  <p>Do not publish real passwords. Store only hashes or redacted examples.</p>

</body>
</html>
