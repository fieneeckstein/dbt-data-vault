# Automatisierte Runs
Zum jetzigen Zeitpunkt sollten Sie das Einführungsbeispiel zu automateDV erfolgreich zum Laufen gebracht haben. Nun werden wir die Datenbank mit einigen Testdaten befüllen und einige Szenarien automatisiert durchspielen und testen, ob das tatsächliche Verhalten mit dem erwarteten Verhalten übereinstimmt. Dieser Abschnitt ist nicht als Tutorial gedacht. Der Arbeitsstand basiert aber auf dem Ergebnis des Tutorials und kann ausgecheckt werden `feature/automated_runs`. Nachfolgend sind die Szenarien beschrieben. 

Zur lokalen Ausführung führen Sie bitte die folgenden Schritte durch:
- Checken Sie den branch `feature/automated_runs` aus. Sie sollten durch die Bearbeitung des Tutorials bereits eine virtuelle Python Umgebung haben. Falls nicht, erstellen Sie sich hier eine und installieren Sie die Abhängigkeiten der `requiremets.txt` gem. Tutorial.
- Kopieren Sie die ausgteilte Datei `run.sh` und den Ordner `data_scripts` auf die selbe Ebene wie den branch.
- Passen Sie das `run.sh` Skript mit ihren Postgres-Credentials an
- Führen Sie die Skript aus. Nach jedem Szenario (s.u.) pausiert das Skript, sodass Sie den Datenbestand kontrollieren können. 

<table>
<colgroup>

</colgroup>
<thead>
  <tr>
    <th></th>
    <th>Skript</th>
    <th>System A</th>
    <th>System B</th>
    <th>Load date</th>
    <th>Star date</th>
    <th>Erwartet in  DV</th>
    <th>Erwartet in DM</th>
  </tr>
</thead>
<tbody>
  <tr>
    <td>RUN_1</td>
    <td>init-dump.sql</td>
    <td>Initaldaten</td>
    <td>Initialdaten</td>
    <td>2024-01-01</td>
    <td>2023-12-12</td>
    <td>Je ein Sat.-Eintrag pro Hub-Eintrag,</td>
    <td>leer</td>
  </tr>
  <tr>
    <td>RUN_2</td>
    <td> ---</td>
    <td> ""</td>
    <td>""</td>
    <td>""</td>
    <td>2024-01-01</td>
    <td>""</td>
    <td>gefüllt</td>
  </tr>
  <tr>
    <td>RUN_3</td>
    <td>run3.sql</td>
    <td>""</td>
    <td>Update: Kunde( #20220019)</td>
    <td>2024-01-02</td>
    <td>2024-01-03</td>
    <td>Neuer Eintrag in sat_customer_crm_details <br></td>
    <td>Das aus System B gespeiste e-mail Spalte sollte sich für den Kunden verändert haben</td>
  </tr>
  <tr>
    <td>RUN_4</td>
    <td>run4.sql</td>
    <td>- Preis von Produkt mit ean #4717784026121 am 4. Januar '24 auf 70€ erhöhen <br>
    - Neues Produkt mit ean #12345 am 4. Januar '24 <br>
  - Neuer Verkauf (Orderno # 11111) am 5. Januar (beide Produkte beteiligt)</td>
    <td>Neuer Kunde(#999)</td>
    <td>2024-01-06</td>
    <td>2024-01-07</td>
    <td>-2 neue Einträge in sat_product_details<br>
    -2 neue Einträge in link_purchase_product,<br>1 neuer Eintrag in sat_purchase_details,<br>
    -1 neuer Eintrag in hub_purchase,<br>
    -1 neuer Eintrag in hub_customer,<br>
    -1 neuer Eintrag in sat_crm_customer_details</td>
    <td>Data Mart auf neuestem Stand</td>
  </tr>
</tbody>
</table>




