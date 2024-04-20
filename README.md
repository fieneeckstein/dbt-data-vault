# (WIP) Tutorial: Data Vault mit [dbt](https://www.getdbt.com/) und [automateDV](https://automate-dv.readthedocs.io/en/latest/)

Dieses Dokument und Repository umfasst die Erstellung eines Data Warehouse mit Data Vault Schema mittels dbt und der Bibliothek automateDV. Die Basistechnologie ist dbt (data build tool) und die Bibliothek automateDV stellt lediglich dbt-Funktionen bereit, die im Kontext von Data Vault nützlich sind.
Das Tutorial wird aufeinander aufbauen und ist dazu gedacht, dass selbst mitprogrammiert wird, um die Effekte in der eigenen Datenbank zu erleben. Sollte trotz Erklärung und Debuggings nicht das erwartete Verhalten auftreten, gibt es zu jedem Branch einen Git-Branch der ausgecheckt werden kann, um mit einem sauberem Entwicklungsstand weiterzumachen.

## Was ist dbt?

dbt ist ein Workflow-Tool, das es ermöglicht Datenpipelines zu deklarieren und automatisiert auszuführen. Ein Anwendungsfall ist die Implementierung von ETL/ELT-Prozessen für Data Warehouses. dbt gibt es in verschiedenen Auslieferungen. In dieser Anleitung wird _dbt Core_ verwendet, welches lokal installiert wird und über ein CLI verwendet wird. dbt verbindet sich gegen eine Datenbank (data platform) und führt dort SQL aus. In dieser Anleitung wird eine Postgres Datenbank verwendet. Da fortan dbt "einfach eingesetzt" wird, empfiehlt es sich einige [Konzepte](https://docs.getdbt.com/docs/build/projects) vorher oder parallel nachzulesen.

## Zielarchitektur

Nach und nach wird eine Datenpipeline entstehen, die die folgende Architektur erzeugt. Da dbt kein Tool ist, das Daten aus verschiedenen Systemen integriert, sondern davon ausgeht, dass die Daten schon alle in einer Datenbank vorliegen und um das Beispiel nicht unnötig komplex zu machen, werden für die verschiedenen Schichten statt eigenständiger Datenbanken verschiedene Datenbank-Schemata verwendet. So werden die Daten dennoch logisch voneinander getrennt.

![](/images/arch.PNG)

## Technische Voraussetzungen

- [Ostfalia Gitlab](https://gitlab-fi.ostfalia.de/)-Account
- [Python](https://www.python.org/downloads/) >=3.8
- [PostgreSQL](https://www.postgresql.org/download/)
- Datenbank-UI (z.B. [DBeaver](https://dbeaver.io/download/) oder [Beekeeper](https://www.beekeeperstudio.io/get))
- Entwicklungsumgebung (z.B. [Visual Studio Code](https://code.visualstudio.com/download))
## 0. Setup
### 0.1 Datenbank anlegen

Wir werden Beispieldaten eines Fahrradverleihs verwenden. Diese Daten müssen im ersten Schritt in eine Datenbank geladen werden, die das operative System des Unternehmens darstellen soll.

- Legen Sie über Ihre DB-UI eine neue Postgres-Verbindung an:

![](/images/db-connection.PNG)

- Führen Sie das ausgehängigte Skript `init-dump-small.sql` aus. Das Skript erzeugt eine Reihe von Tabellen in Ihrer Datenbank und befüllt diese mit Testdaten.
- Betrachten Sie alle Tabellen bis auf crm_customer als System A und crm_customer als System B. Ihr Farhrradverleih hat also zwei operative Systeme, die beide Kundendaten führen.

### 0.2 Installation und Projekt-Setup

- Erstellen Sie von folgendem [Gitlab-Repository](https://gitlab-fi.ostfalia.de/id664409/dbt-vault) eine Fork in Ihren eigenen Namespace. Checken Sie den branch `main` aus
- Navigieren Sie in Ihrem Dateisystem in das Repository
- Virtuelle Python Umgebung (venv) erstellen `python -m venv dbt-vault-venv`
- Stellen Sie sicher, dass venv aktiv ist. Sonst aktivieren: `dbt-vault-venv\Scripts\activate`
- dbt lokal installieren: ` pip install -r requirements.txt`
- Installation kontrollieren: `dbt --version`
- dbt-Projekt initialisieren: `dbt init dbt_vault_tutorial`
  - Datenbank: Postgres
  - Host: localhost
  - port[5432]: mit Enter bestätigen
  - user: ihr postgres-username
  - pass: ihr festgelegtes Passwort des users
  - dbname: bikerental
  - schema: public
  - threads: 1

Nun wurde ein dbt-Projektskelett angelegt, welches im nachfolgend mit Leben gefüllt wird. Außerdem wurde unter (Windows) `C:\Users\XXX\.dbt` eine profiles.yml angelegt. Diese enthält Konfigurationen für verschiedene Development-Stages (dev, prod etc.). Wir brauchen zum jetzigen Zeitpunkt nur ein default-dev-Profil, welches die Verbindungsdaten zur lokalen Postgres-Datenbank enthält.

```yml
dbt_tutorial:
 target: dev
 outputs:
   dev:
     dbname: bikerental
     host: localhost
     pass: **********
     port: 5432
     schema: public
     threads: 1
     type: postgres
     user: postgres
 target: dev
```

- Navigiere in dbt-Projekt: `cd dbt-vault-tutorial`
- Teste Verbindung zur Datenbank: `dbt debug`
- Führe mitgelieferte Models aus: `dbt run`:

![](/images/first-dbt-run.PNG)

- Inspiziere die Datenbank in der UI. Was hat sich verändert? Wie sind diese Änderungen möglicherweise zustande gekommen?
- Unter "models/example" wurden zwei models und eine yml-Datei erzeugt. Beim Ausführen des Befehls scannt dbt das Projekt nach definierten models, sources, tests etc. und erzeugt daraus einen DAG zur Ausführung. Um models auch in anderen Skripten referenzieren zu können, werden models (und andere Skripte) in einer yml-Datei deklariert. Ein Beispiel für eine solche Referenz findet sich in "my_second_dbt_model.sql". Der String in der Referenz entspricht dem model-name in der schema.yml. Die Referenz selbst ist im Jinja-Syntax geschrieben.
- Das waren viele neue Begriffe auf einmal. Recherchieren Sie unbekannte Konzepte und machen Sie sich mit Common Table Expressions und Jina-Syntax in dbt vertraut.

- Probleme? Code bis hier hin im branch `feature/0.2_installation_and_setup`

### 0.3 automateDV installieren

dbt-Packages werden in der `packages.yml` auf selber Ebene, wie die `dbt_project.yml` deklariert. Legen Sie eine Datei mit folgendem Inhalt an:

```
packages:
  - package: Datavault-UK/automate_dv
    version: 0.10.1
```

- Installieren Sie das Package mit `dbt deps`

Nun erscheint im Projekt-Ordner ein Order "dbt packages". Dort sieht man alle installierten dbt packages. Man sieht beispielsweise, dass dbt_utils gleich mitinstalliert wurde. Es kann hilfreich sein, sich über den Funktionsumfang der verschiedenen packages zu informieren, da viele nützliche Funktionen enthalten, die nicht selbst programmiert werden müssen.

- Probleme? Code bis hier hin im branch `feature/0.3_automateDV_installation`

### 0.4 Konfiguration anpassen

- Wie eingangs erwähnt, sollen die verschiedenen Architekturschichten durch packages getrennt werden. Ersetzen Sie in der `dbt_project.yml`den Block zu models durch folgenden Code:

```yml
models:
  dbt_vault_tutorial:
    # Config indicated by + and applies to all files under models/example/
    example:
      +materialized: view
    raw:
      +schema: raw
      +materialized: table
    stage:
      +materialized: view
      +schema: stage
    raw_vault:
      +materialized: incremental
      +schema: raw_vault
    star:
      +materialized: table
      +schema: star
      +tags: star
    utils:
      +schema: utils
```

Der Ausdruck +schema:raw bewirkt beispielsweise, dass alle models, die im Ordner raw liegen in der Datenbank unter dem Schema raw angelegt werden sollen. Das Schema braucht vorher nicht erstellt zu werden, sondern wird von dbt erzeugt.
Diese Konfiguration ist schon Vorarbeit für die weiteren Schritte im Tutorial. Da bisher keine Ordner "raw" oder "stage" etc. existieren, wird dbt Sie bei künftigen Läufen warnen, dasss es zu den angegebenen Pfaden keine Resourcen finden kann.
Diese Warnungen werden aber Schritt für Schritt verschwinden, sobald diese Ordner angelegt und mit Leben gefüllt werden.

- Probleme? Code bis hier hin im branch `feature/0.4_adjust_config`

## 1. Daten des operativen Systems in die Raw Stage laden

In diesem Abschnitt wird der erste ETL-Prozess definiert. Mithilfe von dbt-models sollen die Daten aus dem operativen System in die Raw Stage geladen werden. Die Raw Stage ist eine Zwischenschicht, die in diesem Beispiel einfache Kopien der operativen Tabellen sind. Diese Tabellen enthalten nur eine weitere Information, undzwar den Zeitstempel, zu dem die Daten extrahiert und in die Datawarehouse-Umgebung geladen wurden.

- Für die Organisation der Models legen Sie im Ordner "models" einen neuen Unterordner "raw" an. Dort legen Sie eine Datei `schema.yml` (Dateiname nicht entscheidend, aber Konvention) an. Hier deklarieren Sie, anders als im generierten Beispiel-Model, keine weiteren model, sondern sources, also Datenquellen, die in die Datawarehouse-Platform geladen werden sollen.

```yml
version: 2

sources:
  - name: bikerpoint
    database: bikerental
    schema: public
    tables:
      - name: customer
      .....
      .....
```

- Legen Sie anschließend für jede Tabelle eine Datei nach dem Schema "raw\_{tablename}.sql" an. Jede Datei soll ein Select-Statement enthalten, das die Originaltabelle um eine Spalte mit dem aktuellen Zeitstempel ergänzt. Verwenden Sie zur Angabe der Originaltabelle keinen hart kodierten String, sondern Jinja-Syntax.

Beispiel für `raw_customer.sql`:

```sql
with customers_data as (
    select *, current_timestamp as load_date from {{ source('bikerpoint','customer') }}
)

select * from customers_data
```

- Führen Sie `dbt run ` aus und inspizieren Sie die Änderungen in der Datenbank.
- Probleme? Code bis hier hin im branch `feature/1_load_raw_stage`

### 1.1. Raw Stage mit natürlichen Schlüsseln anreichern

Ziel des Projekts ist die Erzeugung eines Data Vault-Modells. Entscheidend hierfür ist die konsequente Verwendung von natürlichen Schlüsseln, um Daten aus verschiedenen Systemen vereinen zu können. Werfen Sie einen Blick in die zuletzt erzeugte Tabelle raw_item. Sie enthält ausschließlich operative Schlüssel als Referenz auf die beteiligten Produkte und Bestellungen in einer Bestellposition. Diese Informationen in die Raw Stage zu übernehmen ist legitim, aber als Vorbereitung für die Erzeugung der Data Vault sollen nun auch noch natürliche Schlüssel mit in die Tabelle mit aufgenommen werden.

- Passen Sie die Models `raw_item.sql` und `raw_purchase.sql` so an, dass die erezugten Tabellen die natürlichen Schlüssel der referenzierten Tabellen enthalten.
- Verwenden Sie dabei Jinja-Syntax, um auf andere Models zu verweisen. Nur so ist dbt in der Lage die Skripte in der richtigen Reihenfolge auszuführen.

Beispiel für `raw_purchase.sql`:

```sql
with purchase_data as (
    select *, current_timestamp as load_date from {{ source('bikerpoint','purchase') }}
),
customer_nk as (
    select id as cid, customerno from  {{ source('bikerpoint','customer') }}
),
final as (
    select * from purchase_data p left join customer_nk cnk on p.customer_id = cnk.cid
)
select * from final
```

- Führen Sie `dbt run ` aus und inspizieren Sie die Änderungen in der Datenbank.
- Probleme? Code bis hier hin im branch `feature/1.1_add_natural_keys_to_raw_stage`

## 2. Daten aus der Raw Stage in die Hashed Stage laden

In diesem Abschnitt werden wir zum ersten mal automateDV einsetzen und mittels mitgelieferter Funktionen den Staging Layer erzeugen. Diese Schicht reichert die Tabellen aus dem Raw Staging Layer mit weiteren Informatioenn an, die später nützlich sind, um das Data Vault Modell zu erzeugen. Dazu gehören beispielsweise Informationen zu dem Herkunftssystem, oder einem "effective_from"-Flag, falls Kenntnis über den Zeitpunkt des Gültigwerdens eines bestimmten Wert besteht. Beispielsweise führt System A für alle Kundendaten ein "lastupdate"-Feld, welches hierfür verwendet werden kann. Existiert so ein Feld nicht, kann dafür annäherungsweise das load_date verwendet werden.

Im weiteren Verlauf werden natürliche Schlüssel, wie die Kundennummer von hoher Bedeutung sein. Es ist gute Praxis statt der Rohdaten den Hash zu verwenden. automateDV erlaubt es uns deklarativ anzugeben, welche Felder gehasht gespeichert werden sollen. Außerdem kann man deklarativ eine neue Spalte erzuegen, die mehrere Spalten der vorherigen Schicht zusammen hasht und das Ergebnis wiederum abspeichert. Dies ermöglicht später eine einfache Entscheidung, ob sich etwas am Datenbestand verändert hat, oder nicht. Basierend darauf werden später neue Einträge in Satelliten erzeugt.

- Für die Organisation der Models legen Sie im Ordner "models" einen neuen Unterordner "stage" an. Dort legen Sie eine Datei schema.yml an. Hier deklarieren Sie, wie im generierten Besipiel-Model neue Models:

```yaml
version: 2

models:
  - name: stg_customers
  ...
```

- Legen Sie anschließend für jede Tabelle eine Datei nach dem Schema "stg\_{tablename}.sql" an. Jede Datei sollte die automateDV-Macro `stage(...)` aufrufen. Das folgende Beispiel zeigt das Code-Skelett einer solchen Datei. In diesem Tutorial werden alle Variablen zuerst in einem yaml-Dictionary definiert und später dessen Values in das stage-Macro gegeben. Möglicherweise finden Sie bei Ihrer eigenen Recherche weitere Schreibweisen.

```sql
{%- set yaml_metadata -%}
source_model: ...
derived_columns:
  RECORD_SOURCE: ...
  EFFECTIVE_FROM: ...
  LOAD_DATE: ...
  ...: ...
hashed_columns:
  XXX_PK:
    - ...
  XXX_HASHDIFF:
    is_hashdiff: true
    columns:
      - ...
{%- endset -%}

{% set metadata_dict = fromyaml(yaml_metadata) %}
{% set source_model = metadata_dict['source_model'] %}
{% set derived_columns = metadata_dict['derived_columns'] %}
{% set hashed_columns = metadata_dict['hashed_columns'] %}

{{ automate_dv.stage(include_source_columns=true,
                  source_model=source_model,
                  derived_columns=derived_columns,
                  hashed_columns=hashed_columns,
                  ranked_columns=none) }}
```

- Mit dem source_model teilen Sie dem Tool mit, aus welcher Raw-Tabelle die neue Tabelle erzeugt werden soll. Geben Sie hier also den Tabellennamen der Raw-Table an.
- Danach folgt die Deklaration der abgeleiteten Felder. Für RECORD_SOURCE möchten wir einen einfachen String angeben. Dafür schreiben Sie ein Ausrufungszeichen vor den Namen. Für weitere Felder geben Sie an, aus welcher Spalte die Informationen bezogen werden.
- Danach folgt die Deklaration der gehashten Spalten. Hier sollten Sie alle vorkommenden natürlichen Schlüssel angeben.
- Als letztes folgt die Deklaration des Hashes aus mehreren Spalten. Machen Sie sich bewusst, welche Spalten für Sie relevant sind und bei welchen Änderungen sie eine Veränderung in Ihrem Data Warehouse erwarten. Möglicherweise reicht bei Tabellen mit "lastupdate"-Stempel schon die Betrachtung dieses Feldes, bei anderen müssen alle Felder betrachtet werden.
- Es sind weitere Konfigurationen möglich. Ein Blick in die [Dokumentation](https://automate-dv.readthedocs.io/en/latest/macros/stage_macro_configurations/) lohnt sich.

Beispiel für `stg_customers.sql`:

```sql
{%- set yaml_metadata -%}
source_model: 'raw_customer'
derived_columns:
  RECORD_SOURCE: '!raw_customers'
  EFFECTIVE_FROM: lastupdate
  LOAD_DATE: load_date
hashed_columns:
  CUSTOMER_PK:
    - customerno
  CUSTOMER_HASHDIFF:
    is_hashdiff: true
    columns:
      - academictitle
      - address
      - birthdate
      - city
      - creditcard
      - customerno
      - email
      - gender
      - phone
      - postalcode
      - salutation
      - state
      - name
{%- endset -%}

{% set metadata_dict = fromyaml(yaml_metadata) %}
{% set source_model = metadata_dict['source_model'] %}
{% set derived_columns = metadata_dict['derived_columns'] %}
{% set hashed_columns = metadata_dict['hashed_columns'] %}

{{ automate_dv.stage(include_source_columns=true,
                  source_model=source_model,
                  derived_columns=derived_columns,
                  hashed_columns=hashed_columns,
                  ranked_columns=none) }}
```

- Führen Sie `dbt run` aus und inspizieren Sie die Änderungen in der Datenbank. Sie sollten nun eine Reihe von Tabellen im Schema public_stage finden. Diese enthalten die Originalinformationen und zusätzlich generierte Spalten, wie "record_source" und "xxx_hashdiff".
- Probleme? Code bis hier hin im branch `feature/2_load_stage`

## 3. Raw Data Vault erzeugen
Im nächsten Schritt wird automateDV eingesetzt, um die vorbereiteten Daten aus dem Staging Layer in ein Data Vault Schema zu laden. Genannt wird diese Schicht Raw Data Vault, weil hier noch keine Geschäftslogik angewendet wird. Sie dient dazu die Daten verlustfrei in ein Data Vault Schema zu überführen. automateDV stellt für die einzelnen Modellelemente Macros bereit, die wir in den nächsten Abschnitten verwenden werden.

### 3.1. Datenmodellierung

- Nehmen Sie sich einen Moment Zeit und überlegen Sie sich welche (Teile von) Tabellen sinnvolle Kandiaten für Hubs, Links und Satelliten darstellen. Zeichnen Sie einen Vorschlag auf und kennzeichnen Sie, welche Staging-Tabellen zur Erzeugung welcher Data Vault-Tabellen verwendet werden.
- Es gibt mehrere umsetzbare Lösungen. Für den weiteren Verlauf dieser Anleitung wird folgendes Schema verwendet:

![](/images/dv-model.PNG)

- Hinweis: automateDV geht beim Satellitendesign davon aus, dass sich ein Satellit nur auf ein Originalsystem bezieht. Es ist also nicht möglich die Kundeninformationen aus System A und B in einem einzigen Satelliten abzubilden. 

### 3.2. Hubs erzeugen
Bevor wir mit der Erzeugung der Hubs beginnen:
- Für die Organisation der Models legen Sie im Ordner "models" einen neuen Unterordner "raw_vault" an. Dort legen Sie weitere Unterodner "hubs", "links", "sats" an. 
- Im Ordner "raw_vault" legen Sie eine Datei schema.yml an. Hier deklarieren Sie, wie im "stage"-Ordner neue Models. 


Nun beginnen wir mit den Hubs.

- Legen Sie zuerst für jeden Hub eine Datei nach dem Schema "hub\_{name}.sql" an. Jede Datei sollte die automateDV-Macro `hub(...)` aufrufen. Das folgende Beispiel zeigt das Code-Skelett einer solchen Datei. 

```sql 
{% set source_model = ... %}
{% set src_pk = ... %}
{% set src_nk = ... %}
{% set src_ldts = ... %}
{% set src_source = ... %}

{{ automate_dv.hub(src_pk=src_pk, src_nk=src_nk, src_ldts=src_ldts,
                   src_source=src_source, source_model=source_model) }}
```
- Befüllen Sie alle Hub-Models
- Achten Sie darauf, dass der `hub_customer` aus Kunden aus mehreren operativen Systemen vereint. Ziel ist es, dass alle Kunden, unabhängig davon, ob sie aus System A oder B stammen, ein einziges mal im `hub_customer` abgebildet werden. Recherchieren Sie ggf. wie man dies mit automateDV umsetzt.

- Führen Sie `dbt run ` aus und inspizieren Sie die Änderungen in der Datenbank.
- Probleme? Code bis hier hin im branch `feature/3.2_load_hubs`

#### 3.2.1 Probe aufs Exempel
Neue Entitäten:
- Fügen Sie per Insert-Statement in Ihrem operativen System A einen neuen Kunden ein. 
- Führen Sie `dbt run ` aus.
- Sie sollten einen neuen Eintrag im Hub sehen, der sich auf den von Ihnen erzeugnetn Kunden bezieht (erkennbar an der Kundennummer).

Duplikate:
- Machen Sie denselben Kunden auch in System B bekannt.  
- Führen Sie `dbt run ` aus.
- Es sollten keine neuen Einträge in der entsprechenden Hub-Tabelle erzeugt worden sein.


### 3.3. Links erzeugen
Als nächstes erzeugen wir Links, um die Hubs miteinander zu verbinden.
Bevor wir mit der Erzeugung der Hubs beginnen:
- Legen Sie zuerst für jeden Link eine Datei nach dem Schema "link\_{from_name}_{to_name}.sql" an. Jede Datei sollte die automateDV-Macro `link(...)` aufrufen. Das folgende Beispiel zeigt das Code-Skelett einer solchen Datei. 

```sql 
{% set source_model = ... %}
{% set src_pk = ... %}
{% set src_fk = ... %}
{% set src_ldts = ... %}
{% set src_source = ... %}

{{ automate_dv.link(src_pk=src_pk, src_fk=src_fk, src_ldts=src_ldts,
                   src_source=src_source, source_model=source_model) }}
```
- Befüllen Sie alle Link-Models. Der src_pk stellt den Primärschlüssel für den Link dar und die src_fk eine Liste der referenzierten Hub_PKs dar. Für jeden Eintrag in dieser Liste wird eine eigene Spalte im Link erzeugt.
- Ergänzen Sie die `schema.yml` mit den neu angelegten Models.
- Führen Sie `dbt run ` aus und inspizieren Sie die Änderungen in der Datenbank.
- Eine Frage, die Sie sich an diesem Punkt möglicherweise stellen, ist die Frage nach der Historisierbarkeit von Links. Es könnte ja beispielsweise sein, dass bei der Bestellung ein Fehler gemacht wurde und die Stückzahl eines bestimmten Produkts nachträglich nach einem Telefonat erhöht wird. Ist dieser Fall mit diesem Modell abbildbar? Nein. Wollte man dies abbilden, würde man weitere Satelliten anlegen, um die veränderlichen Informationen zu speichern. Probieren Sie es gerne aus. 
- Probleme? Code bis hier hin im branch `feature/3.3_load_links`

#### 3.3.1 Probe aufs Exempel
Sie sollten zum jetzigen Zeitpunkt in beiden Link-Tabellen je einen Eintrag vorfinden. Diese resultieren aus der Bestellung eines Produkts (ean: 4717784026121) von Herrn Lörr (customerno: 20220019). 

Herrn Lörr war zu vorschnell und möchte seiner Bestellung nachträglich das Produkt mit ean 4717784025940 hinzufügen:
- Fügen Sie per Insert-Statement im System A ein neues Item hinzu, das sich auf dieselbe Bestellung, aber auf das andere Produkt bezieht.
- Führen Sie `dbt run ` aus.
- Sie sollten einen neuen Eintrag im `link_purchase_product` sehen.

### 3.4 Satelliten erzeugen
Zuletzt müssen die Satelliten angelegt und befült werden.

- Legen Sie zuerst für jeden Satelliten eine Datei nach dem Schema "sat\_{name}.sql" an. Jede Datei sollte die automateDV-Macro `sat(...)` aufrufen. Das folgende Beispiel zeigt das Code-Skelett einer solchen Datei. 

```sql 
{%- set yaml_metadata -%}
source_model: ...
src_pk: ...
src_hashdiff: 
  source_column: ...
src_payload:
  - ...
  - ...
  
src_eff: ...
src_ldts: ...
src_source: ...
{%- endset -%}

{% set metadata_dict = fromyaml(yaml_metadata) %}

{{ automate_dv.sat(src_pk=metadata_dict["src_pk"],
                   src_hashdiff=metadata_dict["src_hashdiff"],
                   src_payload=metadata_dict["src_payload"],
                   src_eff=metadata_dict["src_eff"],
                   src_ldts=metadata_dict["src_ldts"],
                   src_source=metadata_dict["src_source"],
                   source_model=metadata_dict["source_model"])   }}
```
- Die meisten anzugebenen Felder kennen Sie nun bereits. Neu ist der `src_hashdiff` und der `src_payload`. Der `src_hashdiff` erwartet eine Spalte, die im Staging Layer als hashed_column definiert wurde. Anhand dieses Hashs entscheidet automateDV, ob ein neuer Eintrag im Satelliten gemacht werden muss. Der `src_payload` hingegen deklariert, welche Felder im Klartext im Satelliten selbst gespeichert werden sollen. Es bietet sich hier an, dieselben Felder auszuwählen, wie die, die in die hashed_column eingeflossen sind.  
- Befüllen Sie alle Satelliten-Models. 
- Ergänzen Sie die `schema.yml` mit den neu angelegten Models.
- Führen Sie `dbt run ` aus und inspizieren Sie die Änderungen in der Datenbank.

- Probleme? Code bis hier hin im branch `feature/3.4_load_satellites`

#### 3.4.1 Probe aufs Exempel
Sie sollten nun in den entsprechenden Satelliten pro Hub-Eintrag exakt einen Satelliten-Eintrag vorfinden. 

- Machen Sie sich Gedanken darüber, welche Änderungen in operativen Systemen zu welchen Ergebnissen in der Data Vault führen sollen und verproben Sie das Verhalten.

Neue Produkte:
- Legen Sie in System A ein neues Produkt an. Sie sollten nach `dbt run` einen neuen Eintrag für dieses Produkt im `sat_product_details` sehen.

Veränderte Kundeninformationen:
- Herr Löhr ist in beiden operativen Systemen bekannt und beide Systeme führen seine E-Mail Adresse. Verändern Sie per SQL-Update seine E-Mail Adresse in System A. Sie sollten nach `dbt run` einen neuen Eintrag für diesen Kunden im `sat_customer_details` sehen. `sat_customer_crm_details` bleibt unverändert.



#### 3.4.2 Exkurs: Mehrere Satelliten für einen Hub
Der `hub_customer` hat bereits zwei Satelliten. Dies resultierte aus den zwei operativen Systemen. Auch denkbar wäre es, dass die deskriptiven Informationen *eines* operativen Systems in mehrere Satelliten aufgeteilt werden. Dafür kann es verschiedene Motivationen geben. Beispielsweise eine Aufteilung der Informationen nach Änderungsrate oder die Schaffung von Übersichtlichkeit. 

- Erstellen Sie einen neuen branch für diesen Abschnitt. Der Rest des Tutorials wird nicht auf diesem Arbeitsstand aufbauen, sondern weiter die vorgestellte Zielarchitektur verfolgen. Dieser Abschnitt dient mehr dazu, dass die ausprobieren können "was wäre wenn".
- Überlegen Sie mit Ihren bisher gesammelten Erfahrungen, was in der Theorie und im Code zu tun wäre, damit beispielsweise für den `hub_product` zwei Satelliten erzeugt werden. Einer soll ausschließlich die Preise des Produkts enthalten und der andere die restlichen Produktinformatioenen.
- Setzen Sie die Anforderung um
- Sofern Sie Ihren alten `sat_product_details` weiterverwenden, führen Sie wenn Sie fertig sind `dbt run --full-refresh` aus, damit der Satellit mit neuem Schema erstellt werden kann.

- Probleme? Code bis hier hin im branch `feature/3.4.2_multiple_satellites`
- Vergessen Sie nicht, zurück auf den Arbeitsstand Abschnitt 3.4 bzw. 3.4.1 zu wechseln und danach erneut `dbt run --full-refresh` auszuführen.

## 4 Data Mart befüllen
Die Data Vaullt archiviert Unternehmensinformationen vollständig an einem zentralen Ort. Für analytische Abfragen, kommen aber in der Praxis eher Data Marts zum Einsatz. Diese beziehen ihre Informationen aus der Data Vault und beziehen sich auf eine bestimmte Domäne. Dafür werden die Daten nochmals umorganisiert und teilweise voraggregiert, um die Bedürfnisse der Endanwender gut erfüllen zu können.

In diesem Abschnitt wird ein kleines Star-Schema erzeugt, um zu die Vorgehensweise bei der Erzeugung zu demonstrieren.

![](/images/star-model.PNG)

Die Dimensionstabellen werden hier nicht als Slowly Changing Dimensions modelliert, d.h. es gibt zu jedem Produkt und jedem Kunden exakt einen Eintrag in den Dimensionen. Welche Version eines Produkts bzw. Kunden enthalten ist, soll dynamisch entscheidbar sein. Sollte die Anfrage lauten "Liefere mir alle Saleinformationen, wie sie am 01.01.2023 vorlagen.", würden alle deskriptiven Informationen verwendet werden, die zu diesem Stichtag gültig waren. Wenn der Kunde im Laufe des Jahres 2023 umgezogen ist, würde die selbe Abfrage zum Stichtag 31.12.2023 also ein anderes Ergebnis liefern, da die Dimensionstabellen andere Daten enthalten.

Da es sich bei diesem Data Mart nur um eine Demonstration handelt, verzichten wir auf eine dritte Dimensionstabelle für die Verkaufsdaten. Stattdessen werden die relevanten Felder direkt in der Faktentabelle gespeichert.

Die Umsetzung wird in drei Schritten erfolgen:
1. Hilfstabellen erzeugen
2. Star-Schema unparametrisiert erstellen
3. Star-Schema parametrisieren

### 4.1 Hilfstabellen erzeugen
**Point in time (PIT) tables** sind nützliche Hilfstabellen, die das Laden der Satellitendaten in die Dimensionstabellen vereinfacht und beschleunigt. Sie geben für jeden Business Key Auskunft darüber welche Satelliteneinträge an einem bestimmten Datum gültig waren. Die Pflege solcher Tabellen macht also insbesondere dann Sinn, wenn an einem Business Key mehrere Satelliten hängen. Sollten Sie mit PIT-Tabellen nicht vertraut sein, nehmen Sie sich einen Moment Zeit, um das Konzept zu verstehen.

automateDV bietet zur Erzeugung solcher PIT-Tabellen ein Macro an, welches wir auch verwenden werden. Nachfolgendes `pit_customer.sql`-Model erzeugt eine PIT-Tabelle für Kunden.
```sql 
{{ config(materialized='pit_incremental', enabled=true) }}

{%- set yaml_metadata -%}
source_model: hub_customer
src_pk: CUSTOMER_PK
src_ldts: LOAD_DATE
as_of_dates_table: as_of_date
satellites: 
  sat_customer_details:
    pk:
      PK: CUSTOMER_PK
    ldts:
      LDTS: LOAD_DATE
  sat_customer_crm_details:
    pk:
      PK: CUSTOMER_PK
    ldts:
      LDTS: LOAD_DATE
  
stage_tables_ldts: 
  stg_customers: LOAD_DATE  
  stg_crm_customer: LOAD_DATE
{%- endset -%}

{% set metadata_dict = fromyaml(yaml_metadata) %}

{% set source_model = metadata_dict['source_model'] %}
{% set src_pk = metadata_dict['src_pk'] %}
{% set as_of_dates_table = metadata_dict['as_of_dates_table'] %}
{% set satellites = metadata_dict['satellites'] %}
{% set stage_tables_ldts = metadata_dict['stage_tables_ldts'] %}
{% set src_ldts = metadata_dict['src_ldts'] %}

{{ automate_dv.pit(source_model=source_model, src_pk=src_pk,
                   as_of_dates_table=as_of_dates_table,
                   satellites=satellites,
                   stage_tables_ldts=stage_tables_ldts,
                   src_ldts=src_ldts) }}
```

- Übernehmen Sie den Code in eine Datei `pit_customer.sql` im Ordner `utils`.
- Schreiben Sie ein weiteres Model zur Erezugung einer Pit-Tabelle für Produkte in `pit_product.sql`
- Legen Sie wie gewohnt eine `schema.yml` im `utils`-Ordner an. 

**As of date-Tables:** sind ebenso Hilfstabellen, die für einen bestimmten Zeitraum Daten in einem bestimmten Abstand erzeugen. Bei genauerem Hinsehen wurde in den PIT-Skripten fällt auf, dass genau so eine Tabelle für dessen Erezeugung verwendet wird. Dementsprechend müssen wir mit einem Model dafür sorgen, dass die eine as-of-date-Tabelle erzeugt wird. Auch dafür bietet automateDV ein Macro, welches Sie wiefolgt verwenden:
- Legen Sie unter `utils` ein Model `as_of_date.sql` an und fügen Sie folgenden Inhalt ein:

```sql 
{{ config(materialized='table') }}

{%- set datepart = "day" -%}
{%- set start_date = "TO_DATE('2022-01-01', 'yyyy-mm-dd')" -%}
{%- set end_date = "TO_DATE('2024-12-31', 'yyyy-mm-dd')" -%}

WITH as_of_date AS (
    {{ dbt_utils.date_spine(datepart=datepart, 
                            start_date=start_date,
                            end_date=end_date) }}
)

SELECT DATE_{{datepart}} as AS_OF_DATE FROM as_of_date
```
- Ergänzen Sie die `schema.yml`
- Führen Sie `dbt run ` aus und inspizieren Sie die Änderungen in der Datenbank.
- Probieren Sie aus, was passiert, wenn Sie im Model andere Parameter setzen.
- Probleme? Code bis hier hin im branch `feature/4.1_helper_tables`
- Hinweis: Die PIT-Tabellen sind so eingestellt, dass sie tracken, zu welchem Zeitpunkt welche Infromationen innerhalb der DWH-Umgebung bekannt waren, nicht zu welchem Zeitpunkt eine Information im operativen System bekannt war. Bsp: Wird ein Preis also im operativen System an T0 um 00:00 Uhr von 10€ auf 20€ erhöht wird, der ETL-Prozess das Update 02:00 Uhr registriert und an T1 eine Anfrage nach dem Systemzustand an T0 01:00 eingeht, wird als aktueller Preis 10 € verwendet.
 
### 4.2 Produktdimension erstellen
In diesem Abschnitt soll die Dimensionstabelle für Produkte mit denjenigen Satelliten-Informationen befüllt werden, die *heute* gültig waren. Die Anpassung auf dynamische Daten folgt später. Da die PIT-Tabellen für jeden Tag um 00:00 Uhr tracken, welcher Satellit aktiv ist, verwenden Sie in ihrer Query das Datum von morgen.

Hier endet der Scope von automateDV. Für Dimensions- und Faktentabellen gibt es keine fertigen Macros. Wir müssen also den SQL-Code selbst schreiben.

Auskunft darüber, welcher Satelliten-Eintrag heute gültig ist, gibt die entsprechende PIT-Tabelle. 
- Legen Sie im Ordner `star` eine `schmema.yml` an.
- Legen Sie ein Model `dim_product.sql` an und ergänzen Sie dieses in der `schema.yml`
- Schreiben Sie eine CTE, die zuerst aus der PIT-Tabelle den aktiven Satelliteneintrag selektiert und mit dieser Information schließlich die gültigen Attribute aus dem Satelliten selektiert. Achten Sie darauf, dass Sie bei der Angabe der Tabellen Ihrer CTE den Jinja-Syntax verwenden.

Das fertige Model kann dann zum Beipsiel so aussehen:
```sql
with active_satellite_entry as (
select product_pk as active_ppk, sat_product_details_ldts as active_ldts from {{ ref('pit_product') }} where  as_of_date  = current_date + 1
),

final as (
    select product_pk, ean, price from {{ ref('sat_product_details') }} join active_satellite_entry a on product_pk=active_ppk and load_date = active_ldts
)

select * from final
```

- Führen Sie `dbt run ` aus und inspizieren Sie die Änderungen in der Datenbank. Sie sollten in der Tabelle `dim_product` nun zwei Einträge sehen.
- Probleme? Code bis hier hin im branch `feature/4.2_load_dim_product`

### 4.3 Kundendimension erstellen
- Gehen Sie analog vor, um die Dimensionstabelle für Kunden zu erzeugen. Die E-Mail Adresse der Kunden wird in zwei Satelliten geführt. Verwenden Sie alle zur Verfügung stehenden Daten für die Befüllung der Dimensionstabelle. Die e-mail Adresse kommt in beiden Systemen vor. Da es vorkommen kann, dass diese sich von System zu System unterscheidet, nehmen Sie in der Dimensionstabelle beide Werte in einer separaten Spalte auf. Ein merge wäre hier auch denkbar, aber die Dopplung macht die Umsetzung fürs erste einfacher.
- Überlegen Sie genau wie Sie die Informationen der beiden Satelliten joinen müssen.
- Führen Sie `dbt run ` aus und inspizieren Sie die Änderungen in der Datenbank. Sie sollten in der Tabelle `dim_customer` nun 5 Einträge (Einen pro Kunde) sehen.
- Probleme? Code bis hier hin im branch `feature/4.3_load_dim_customer`

### 4.4 Faktentabelle erstellen
Wie eingangs erwähnt, verzichten wir auf das Anlegen einer dritten Dimension für Verkäufe. Wir gehen in diesem Abschnitt ausnahmsweise davon aus, dass sich Verkäufe nicht mehr verändern und schon mit allen relevanten Informationen vorliegen.

- Legen Sie ein Model `fct_sale.sql` an und ergänzen Sie dieses in der `schema.yml`
- Überlegen Sie sich, wie Sie die Kennzahlen *waiting_time (Zeit zwischen Bestelleingang und Liferung)* und *delivery_time(Zeit für die Auslieferung)* berechnen können. 
- Schreiben sie als ersten Teil der CTE ein SQL-Statement, das alle relevanten Informationen aus `sat_purchase_details` selektiert.
-  Überlegen Sie sich danach wie Sie die Kennzahl *total sale (Rechnungsbetrag)* berechnen können.
-  Schreiben Sie eine weitere Query, die die Rechnungsbeträge aller Bestellungen zu den aktuellen Preisen berechnet.
-  Schreiben Sie weitere Queries, die aus den Dimensionstabellen die gehashten und natürlichen Schlüssel selektiert.
-  Kombinieren Sie die Teilergebnisse mit einem Join-Statement, um für jede Bestellung einen Eintrag in der Faktentabelle zu erzeugen.

- Führen Sie `dbt run` aus und inspizieren Sie die Änderungen in der Datenbank. Sie sollten in der Tabelle `fct_sale` nun einen Eintrag sehen.
- Probleme? Code bis hier hin im branch `feature/4.4_load_fct_sale`

### 4.5 Parametrisierung
In diesem Abschnitt werden wir dafür sorgen, dass der Data Mart per Kommandozeile zu einem anderen Stichtag generiert werden kann. 

- Hierfür wird zunächst eine Variable definiert, die über die Komandozeile gesetzt werden kann. Fügen Sie in der `dbt_project.yml` folgenden Inhalt ein:
```yaml
vars:
  star_date: 2024-01-01
```
Damit haben Sie den default-Wert für die Variable *star_date* gesetzt.

- Als nächstes passen Sie in allen Dimensionstabellen die Where-Klauseln folgendermaßen an:
```sql
  where as_of_date = to_date('{{var('star_date')}}' ,'yyyy-mm-dd') 
```
- Führen Sie nun `dbt run --vars "star_date: 2024-23-01"` aus (Sie können ein beliebiges Datum das mindestens einen Tag in der Zukunft verwenden, das aber innerhalb der Zeitspanne der as_of_date-Tabelle liegt)
- Probleme? Code bis hier hin im branch `feature/4.5_parameterize_data_mart`

### 4.6 Probe aufs Exempel
- Da Sie dieses Tutorial höchstwahrscheinlich in einem oder wenigen Tagen bearbeiten und sich bei einer as_of_date-Tabelle, die tagesgenau ist die Veranschaulichung von Beispielszenarien schwierig gestaltet, werden wir zunächst die `load_date`-Spalten manipulieren und so eine kleine Zeitreise simulieren.

- Bei der Extraktion der operativen Daten (Alle models im `raw`-Ordner) haben Sie die Spalte `load_date` auf den aktuellen Zeitpunkt gesetzt. Passen Sie alle Skripte an, sodass statt *current_timestamp* folgender Ausdruck verwendet wird: 
  ```sql
  to_date('{{var('load_date')}}' ,'yyyy-mm-dd')
  ```
- Legen Sie anschließend die Variable wie zuvor in der `dbt_project.yml` an.
- Wenn Sie nun beide Parameter dynamisch setzen möchten, verwenden Sie  `dbt run --vars "{star_date: 2023-12-12, load_date: 2024-01-24}"` (mit beliebigen Daten)

Machen Sie sich mit dem Verhalten der Pipeline vertraut. Probieren Sie beispielsweise folgendes Szenario aus:
1. Spielen Sie das `init-dump-small.sql`-Skript neu ein und erzeugen Sie Ihr DWH von Grund auf neu: `dbt run --full-refresh --vars "{star_date: 2023-12-31, load_date: 2024-04-30}"` um zu simulieren, dass die Daten am 30.04.2022 extrahiert wurden und der Data Mart zum Stichtag 31.12.2023 erzeugt wurde. Die Dimensionstabellen sollten korrekterweise leer sein. Woran liegt das?
2. Führen Sie `dbt run --vars "{star_date: 2024-05-31, load_date: 2024-04-30}"` aus. Nun sollten die Dimensionstabellen mit den Informationen aus dem operativen System gefüllt sein, da ja noch keine Updates o.Ä. gemacht wurden.
3. Ändern Sie den Preis des Produkts mit id=1 in System A per Update-Statement. Führen Sie `dbt run --vars "{star_date: 2024-05-01, load_date: 2024-05-15}"`. Die Dimensions- und Faktentabellen haben sich nicht verändert. Wieso?
4. Führen Sie `dbt run --vars "{star_date: 2024-05-31, load_date: 2024-05-15}"`. Wie sehen die Tabellen jetzt aus?
5. Probieren Sie weitere Szenarien selbstständig aus. Falls Sie sich verzetteln, können Sie immer die Daten neu einspielen und dbt mit `--full-refresh` starten.

- Probleme? Code bis hier hin im branch `feature/4.6_manipulate_load_date`

## 5. Mögliche Erweiterungen/Übungsaufgaben (@Frank)
- In früheren Schritten wurden schon die `effective_from`-flags vorbereitet. Man könnte nun noch einen weiteren Data Mart basierend auf diesen Daten erstellen
- Man könnte einen merge-Schritt bei mehreren Satelliten einbauen (2 Satelliten liefern verschiedene E-Mail Adressen -> Verwendung des jüngeren Werts bspw.)

