---
name: adrs-consolidate
description: Konsolidiert die ADRs in docs/decisions zu einem bereinigten Satz, der nur den aktuell gültigen Stand enthält. Abgelöste Entscheidungen entfallen, alte ADRs werden nach Setzen eines Git-Tags gelöscht. Nur verwenden, wenn ausdrücklich eine ADR-Destillation oder -Konsolidierung gewünscht ist.
disable-model-invocation: true
---

# Aufgabe: ADRs in docs/decisions destillieren

Ziel ist ein bereinigter Satz von ADRs, der ausschließlich den aktuell gültigen
Stand beschreibt. Abgelöste Entscheidungen werden nicht übernommen, sondern
entfallen. Die noch gültigen Entscheidungen werden thematisch passend zu neuen
ADRs zusammengeführt. Bei teilweisen Ablösungen wird nur der weiterhin gültige
Teil des älteren ADR übernommen. Die alten ADRs werden am Ende gelöscht; die
Historie bleibt über Git erhalten. Du lieferst Analysen, Entwürfe und Fragen;
die Entscheidungen treffe ich.

## Grundregeln (gelten für alle Phasen)
- Bis Phase 4 keine bestehenden ADRs ändern oder löschen.
- Keinen Produktivcode ändern.
- Keine Begründungen erfinden. Wenn ein "Warum" nicht aus den ADRs hervorgeht,
  markiere es als `[OFFEN: Begründung fehlt]`.
- Jeder neue ADR nennt die alten ADRs, aus denen er entstanden ist.
- Unsicherheiten, Widersprüche und Interpretationen explizit kennzeichnen, nicht glätten.
- Arbeitsdateien kommen nach `docs/decisions/_distill/`.
- Tag-Name für die Historie: `adr-pre-distill-YYYY-MM-DD-HHMM` (Ortszeit).
  Lege den konkreten Namen zu Beginn von Phase 3 fest, schreibe ihn in
  `_distill/tag-name.txt` und verwende ab dann überall exakt diesen Namen.
  Existiert der Tag beim Setzen in Phase 4 bereits, abbrechen und mich fragen.
- Nach jeder Phase: kurze Zusammenfassung, dann STOPP und auf mein OK warten.

## Phase 1: Inventar
Lies alle Dateien in `docs/decisions/` und erstelle `_distill/01-inventory.md` mit:
1. Einer Tabelle: ID, Titel, Datum, Status, ersetzt, ersetzt durch, Themenbereich.
2. Dem Ablösungsgraphen (gern als Mermaid), inklusive *teilweiser* Ablösungen,
   also Fälle, in denen ein neuerer ADR nur einen Aspekt eines älteren ändert.
3. Auffälligkeiten: fehlende oder inkonsistente Status, Ablösungen, die nur
   implizit sind (neuer ADR widerspricht altem, ohne ihn zu referenzieren),
   ADRs ohne erkennbare Entscheidung.
4. Eine Beschreibung des bisher verwendeten ADR-Formats (Aufbau, Dateinamen,
   Nummerierung), damit die neuen ADRs dazu passen.

## Phase 2: Neuer Zuschnitt
Erstelle `_distill/02-mapping.md` mit einem Vorschlag, wie die alten ADRs zu
neuen zusammengeführt werden:
- Liste der geplanten neuen ADRs mit Arbeitstitel und Kurzbeschreibung
- Zuordnung alt → neu (jeder alte ADR taucht genau einmal auf, entweder
  einem neuen ADR zugeordnet oder als "entfällt" mit Begründung, z. B.
  vollständig abgelöst oder Komponente existiert nicht mehr). Bei teilweise
  abgelösten ADRs angeben, welcher Teil weiterhin gilt und übernommen wird.
- Vorschlag zur Nummerierung: neu bei 0001 beginnen oder bisherige Reihe fortsetzen,
  mit kurzer Abwägung
Leitlinie für den Zuschnitt: Ein neuer ADR bündelt eine zusammenhängende
Entscheidung, nicht ein ganzes Themengebiet. Lieber mehrere fokussierte ADRs
als ein Sammel-ADR.

## Phase 3: Entwürfe und Abgleich mit dem Code
Nach meinem OK zum Zuschnitt:
1. Tag-Namen festlegen und in `_distill/tag-name.txt` schreiben (siehe Grundregeln).
2. Entwirf die neuen ADRs in `_distill/new/` im bisherigen Format. Jeder ADR enthält
   mindestens: Kontext, Entscheidung, verworfene Alternativen (nur die wichtigsten),
   Konsequenzen, sowie einen Abschnitt **Herkunft** mit den Quell-ADRs und dem
   Hinweis, dass diese im Git-Tag aus `_distill/tag-name.txt` einsehbar sind.
   Abgelöste frühere Entscheidungen können bei den verworfenen Alternativen in
   einem Satz erscheinen, wenn der Grund der Ablösung für das Verständnis der
   aktuellen Entscheidung wichtig ist.
   Markiere pro ADR den Status der Destillation: eindeutig / interpretiert / widersprüchlich.
3. Prüfe jede Entscheidung gegen die tatsächliche Codebasis und erstelle
   `_distill/03-code-check.md`. Pro neuem ADR eine Einstufung:
   - ✅ konsistent (mit Beleg: Datei/Stelle)
   - ⚠️ Abweichung (was der Code tatsächlich tut, mit Dateiverweisen)
   - ❓ nicht überprüfbar (z. B. Prozess- oder Infrastrukturentscheidung)
   Keine Korrekturen vornehmen, nur dokumentieren.

## Phase 4: Fragen und Fertigstellung
Erstelle `_distill/04-questions.md` mit allen offenen Punkten aus Phase 2 und 3,
jeweils als konkrete Frage an mich, mit deiner Einschätzung und möglichen Optionen.
Bei Abweichungen immer die Frage: ADR anpassen oder Code anpassen?

Nach meinen Antworten:
1. Neue ADRs in `_distill/new/` entsprechend meinen Antworten finalisieren.
   Wo ich eine Entscheidung inhaltlich geändert habe, dies im Kontext des ADR
   kurz festhalten.
2. Git-Tag mit dem Namen aus `_distill/tag-name.txt` auf den aktuellen Stand
   setzen (vor dem Löschen!).
3. Alle alten ADRs mit `git rm` entfernen und die neuen ADRs nach
   `docs/decisions/` verschieben.
4. In `CLAUDE.md` ergänzen: Die ADRs in `docs/decisions/` sind die verbindliche
   Quelle für Architekturentscheidungen. Frühere ADRs sind im Tag
   `<Name aus tag-name.txt>` einsehbar, gelten aber nicht als Vorgabe.
   Falls dort bereits ein Verweis auf einen früheren Destillations-Tag steht,
   diesen beibehalten und den neuen ergänzen.
5. Code-Abweichungen, bei denen ich "Code anpassen" gewählt habe, als
   Aufgabenliste in `_distill/05-followups.md` festhalten, nicht direkt umsetzen.
6. Prüfen, dass keine Datei im Repo mehr auf gelöschte ADR-Dateien verweist
   (Links, Kommentare im Code, CLAUDE.md), und Fundstellen auflisten.

Beginne mit Phase 1.
