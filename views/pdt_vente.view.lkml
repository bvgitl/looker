view: pdt_vente {
  derived_table: {
    sql: SELECT DISTINCT
    m.Animateur AS Animateur,
    m.DATE_OUV AS Dte_Ouverture,
    m.Directeur AS Directeur,
    m.Franchise AS Franchise,
    m.Nom_TBE AS NOM,
    m.Type_TBE AS Typ,
    m.Pays_TBE AS Pays,
    m.Region AS Region,
    m.SURF_VTE AS Surface,
    m.TYP_MAG AS TYP_MAG,
    m.Tranche_age AS Anciennete,
    m.CD_Magasin AS CD_Magasin,
    m.Latitude,
    m.Longitude,
    m2.Animateur AS Animateur_histo,
    m2.DATE_OUV AS Dte_Ouverture_histo,
    m2.Directeur AS Directeur_histo,
    m2.Franchise AS Franchise_histo,
    m2.Nom_TBE as NOM_histo,
    m2.Type_TBE as Typ_histo,
    m2.Pays_TBE as Pays_histo ,
    m2.Region as Region_histo ,
    m2.SURF_VTE as Surface_histo ,
    m2.TYP_MAG as TYP_MAG_histo,
    m2.Tranche_age as Anciennete_histo,
    m2.Latitude as Latitude_histo,
    m2.Longitude as Longitude_histo,
    day AS Dte_Vte,
    v.Typ_Vente AS Typ_Vente,
    v.Val_Achat_Gbl AS Val_Achat_Gbl,
    v.Qtite AS Qtite,
    v.ca_ht AS ca_ht,
    v.marge_brute AS marge_brute,
    mag.nb_ticket AS nb_ticket,
    c.nbre_commande AS nbre_commande,
    c.Tarif_HT_livraison AS Tarif_HT_livraison,
    c.Total_HT AS Total_HT,
    v.StatutBcp,
    v.StatutGoogleSheet
FROM ( SELECT day FROM UNNEST( GENERATE_DATE_ARRAY(DATE('2018-01-02'), CURRENT_DATE(), INTERVAL 1 DAY) ) AS day )
LEFT JOIN
(
    SELECT
        CD_Magasin,
        Dte_Vte,
        Typ_Vente,
        SUM(Val_Achat_Gbl) AS Val_Achat_Gbl,
        SUM(Qtite) AS Qtite,
        SUM(ca_ht) AS ca_ht,
        SUM(marge_brute) AS marge_brute,
        MAX(StatutBcp) AS StatutBcp,
        MIN(StatutGoogleSheet) AS StatutGoogleSheet
    FROM
    (
        SELECT
            CD_Magasin,
            Dte_Vte,
            Typ_Vente,
            Val_Achat_Gbl,
            Qtite,
            ca_ht,
            marge_brute,
            'BCP reçu' AS StatutBcp,
            'GoogleSheet vierge' AS StatutGoogleSheet
        FROM `bv-prod.Matillion_Perm_Table.TF_VENTE`
        UNION ALL
        SELECT
            CODE_ACTEUR AS CD_Magasin,
            DTE_VENTE,
            TYP_VENTE,
            VAL_ACHAT_GBL AS Val_Achat_Gbl,
            QTITE AS Qtite,
            CA_HT AS ca_ht,
            MARGE_BRUTE AS marge_brute,
            'BCP non reçu' AS StatutBcp,
            'GoogleSheet renseignée' AS StatutGoogleSheet
        FROM `bv-prod.Matillion_Perm_Table.DATA_QUALITY_VENTES_GOOGLE_SHEET`
        UNION ALL
        SELECT
            mf.CodeMagasinActeur AS CD_Magasin,
            mf.DateFichier AS DTE_VENTE,
            0 AS TYP_VENTE,
            null AS Val_Achat_Gbl,
            null AS Qtite,
            null AS ca_ht,
            null AS marge_brute,
            'BCP non reçu' AS StatutBcp,
            'GoogleSheet vierge' AS StatutGoogleSheet
        FROM `bv-prod.Matillion_Monitoring.MonitoringFichier` mf
        WHERE mf.Flux = 'BCP10_BCP13'
        AND NOT EXISTS
        (
            SELECT *
            FROM `bv-prod.Matillion_Perm_Table.TF_VENTE` tf
            WHERE tf.CD_Magasin = mf.CodeMagasinActeur
            AND tf.Dte_Vte = mf.DateFichier
        )
        AND NOT EXISTS
        (
            SELECT *
            FROM `bv-prod.Matillion_Perm_Table.DATA_QUALITY_VENTES_GOOGLE_SHEET` gs
            WHERE gs.CODE_ACTEUR = mf.CodeMagasinActeur
            AND gs.DTE_VENTE = mf.DateFichier
        )
    )
    GROUP BY 1, 2, 3
  ) v
  INNER JOIN
  (
    SELECT
        CD_Magasin,
        Dte_Vte,
        Typ_vente,
        SUM(nb_ticket) AS nb_ticket
    FROM
    (
        SELECT
            CD_Magasin,
            Dte_Vte,
            Typ_vente,
            nb_ticket
        FROM `bv-prod.Matillion_Perm_Table.TF_VENTE_MAG`
        UNION ALL
        SELECT
            CODE_ACTEUR AS CD_Magasin,
            DTE_VENTE,
            TYP_VENTE,
            NB_TICKET AS nb_ticket
        FROM `bv-prod.Matillion_Perm_Table.DATA_QUALITY_VENTES_GOOGLE_SHEET`
        UNION ALL
        SELECT
            mf.CodeMagasinActeur AS CD_Magasin,
            mf.DateFichier AS DTE_VENTE,
            0 AS TYP_VENTE,
            null AS nb_ticket
        FROM `bv-prod.Matillion_Monitoring.MonitoringFichier` mf
        WHERE mf.Flux = 'BCP10_BCP13'
        AND NOT EXISTS
        (
            SELECT *
            FROM `bv-prod.Matillion_Perm_Table.TF_VENTE_MAG` tf
            WHERE tf.CD_Magasin = mf.CodeMagasinActeur
            AND tf.Dte_Vte = mf.DateFichier
        )
        AND NOT EXISTS
        (
            SELECT *
            FROM `bv-prod.Matillion_Perm_Table.DATA_QUALITY_VENTES_GOOGLE_SHEET` gs
            WHERE gs.CODE_ACTEUR = mf.CodeMagasinActeur
            AND gs.DTE_VENTE = mf.DateFichier
        )
    )
    GROUP BY 1, 2, 3
  ) mag
  ON
    mag.CD_Magasin = v.CD_Magasin
    AND mag.Dte_Vte = v.Dte_Vte
    AND v.Typ_vente = mag.Typ_vente
ON  day = v.Dte_Vte
LEFT JOIN `bv-prod.Matillion_Perm_Table.Magasins` m ON m.CD_Magasin = v.CD_Magasin
LEFT JOIN `bv-prod.Matillion_Perm_Table.Magasins_Histo` m2 ON v.CD_Magasin = m2.CD_Magasin AND m2.ScdDateDebut <= v.Dte_vte AND v.Dte_vte < m2.ScdDateFin
LEFT JOIN (
  SELECT
    cd_magasin,
    CAST(DATETIME_TRUNC(DATETIME(dte_commande),
        DAY) AS DATE) AS dte_cde,
    COUNT(DISTINCT(cd_commande)) AS Nbre_commande,
    SUM(Tarif_HT_livraison) AS Tarif_HT_livraison,
    SUM(Total_HT) AS Total_HT
  FROM
    `bv-prod.Matillion_Perm_Table.COMMANDES`
  WHERE
    statut IN ("pending",
      "processing",
      "fraud",
      "complete")
  GROUP BY 1, 2 ) AS c
ON
  c.cd_magasin = m.CD_Magasin
  AND day = c.dte_cde
  AND v.Typ_Vente = 0

 ;;

      persist_for: "2 hours"
    }

    measure: count {
      hidden: yes
      type: count
      drill_fields: [detail*]
    }

    dimension: cd_magasin {
      type: string
      sql: ${TABLE}.CD_Magasin ;;
      view_label: "Magasins (actuel)"
    }

    dimension: animateur {
      type: string
      sql: ${TABLE}.Animateur ;;
      label : "Animateur"
      view_label: "Magasins (actuel)"
    }

    dimension: directeur {
      type: string
      sql: ${TABLE}.Directeur ;;
      label : "Directeur"
      view_label: "Magasins (actuel)"
    }

    dimension: franchise {
      type: string
      sql: ${TABLE}.Franchise ;;
      label : "Franchise"
      view_label: "Magasins (actuel)"
    }

    dimension: nom {
      type: string
      sql: ${TABLE}.NOM ;;
      label : "Nom"
      view_label: "Magasins (actuel)"
    }

    dimension: typ {
      type: string
      sql: ${TABLE}.Typ ;;
      label : "Type"
      view_label: "Magasins (actuel)"
    }

    dimension: pays {
      type: string
      sql: ${TABLE}.Pays ;;
      label : "Pays"
      view_label: "Magasins (actuel)"
    }

    dimension: region {
      type: string
      sql: ${TABLE}.Region ;;
      label : "Région"
      view_label: "Magasins (actuel)"
    }

    dimension: surface {
      type: number
      sql: ${TABLE}.Surface ;;
      label : "Surface"
      view_label: "Magasins (actuel)"
    }

    dimension: typ_mag {
      type: string
      sql: ${TABLE}.TYP_MAG ;;
      label : "Type Magasin"
      view_label: "Magasins (actuel)"
    }

    dimension: anciennete {
      type: string
      sql: ${TABLE}.Anciennete ;;
      label : "Ancienneté"
      view_label: "Magasins (actuel)"
    }

    dimension_group: dte_ouverture {
      type: time
      timeframes: [
        raw,
        date,
        year
      ]
      convert_tz: no
      datatype: date
      sql: ${TABLE}.Dte_Ouverture ;;
      label : "Date Ouverture"
      view_label: "Magasins (actuel)"
    }


  dimension: animateur_histo {
    type: string
    sql: ${TABLE}.Animateur_histo ;;
    label: "Animateur (histo)"
    view_label: "Magasins (à date de vente)"
  }

  dimension: directeur_histo {
    type: string
    sql: ${TABLE}.Directeur_histo ;;
    label: "Directeur (histo)"
    view_label: "Magasins (à date de vente)"
  }

  dimension: franchise_histo {
    type: string
    sql: ${TABLE}.Franchise_histo ;;
    label: "Franchise (histo)"
    view_label: "Magasins (à date de vente)"
  }

  dimension: nom_histo {
    type: string
    sql: ${TABLE}.NOM_histo ;;
    label: "Nom (histo)"
    view_label: "Magasins (à date de vente)"
  }

  dimension: typ_histo {
    type: string
    sql: ${TABLE}.Typ_histo ;;
    label: "Type (histo)"
    view_label: "Magasins (à date de vente)"
  }

  dimension: pays_histo {
    type: string
    sql: ${TABLE}.Pays_histo ;;
    label: "Pays (histo)"
    view_label: "Magasins (à date de vente)"
  }

  dimension: region_histo {
    type: string
    sql: ${TABLE}.Region_histo ;;
    label: "Région (histo)"
    view_label: "Magasins (à date de vente)"
  }

  dimension: surface_histo {
    type: number
    sql: ${TABLE}.Surface_histo ;;
    label: "Surface (histo)"
    view_label: "Magasins (à date de vente)"
  }

  dimension: typ_mag_histo {
    type: string
    sql: ${TABLE}.TYP_MAG_histo ;;
    label: "Type Magasin (histo)"
    view_label: "Magasins (à date de vente)"
  }

  dimension: anciennete_histo {
    type: string
    sql: ${TABLE}.Anciennete_histo ;;
    label: "Ancienneté (histo)"
    view_label: "Magasins (à date de vente)"
  }

  dimension_group: dte_ouverture_histo {
    type: time
    timeframes: [
      raw,
      date,
      year
    ]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.Dte_Ouverture_histo ;;
    label: "Date Ouverture (histo)"
    view_label: "Magasins (à date de vente)"
  }



    dimension_group: dte_vte {
      type: time
      timeframes: [
        raw, date, week, month, month_name, quarter, year,
        fiscal_month_num, fiscal_quarter, fiscal_quarter_of_year, fiscal_year
      ]
      convert_tz: no
      datatype: date
      sql: ${TABLE}.Dte_Vte ;;
      view_label: "Ventes"
    }

    dimension: typ_vente {
      type: number
      sql: ${TABLE}.Typ_Vente ;;
      view_label: "Ventes"
    }

    dimension: val_achat_gbl {
      type: number
      sql: ${TABLE}.Val_Achat_Gbl ;;
      view_label: "Ventes"
    }

    dimension: qtite {
      type: number
      sql: ${TABLE}.Qtite ;;
      view_label: "Ventes"
    }

    dimension: ca_ht {
      type: number
      sql: ${TABLE}.ca_ht ;;
      view_label: "Ventes"
    }

    dimension: marge_brute {
      type: number
      sql: ${TABLE}.marge_brute ;;
      view_label: "Ventes"
    }

    dimension: nb_ticket {
      type: number
      sql: ${TABLE}.nb_ticket ;;
      view_label: "Ventes"
    }

    dimension: total_ht {
      type: number
      sql: ${TABLE}.Total_HT ;;
      view_label: "Web"
    }


    dimension: tarif_ht_livraison {
      type: number
      sql: ${TABLE}.Tarif_HT_livraison ;;
      view_label: "Web"
    }

    dimension: nbre_commande {
      type: number
      sql: ${TABLE}.Nbre_commande ;;
      view_label: "Web"
    }

    dimension: statut_bcp {
      type: string
      sql: ${TABLE}.StatutBcp ;;
      label: "Statut BCP"
      view_label: "Ventes"
    }

  dimension: statut_google_sheet {
      type: string
      sql: ${TABLE}.StatutGoogleSheet ;;
      label: "Statut GoogleSheet"
      view_label: "Ventes"
    }

    set: detail {
      fields: [
        cd_magasin,
        animateur,
        directeur,
        franchise,
        nom,
        typ,
        pays,
        region,
        surface,
        typ_mag,
        anciennete,
        typ_vente,
        val_achat_gbl,
        qtite,
        ca_ht,
        marge_brute,
        nb_ticket,
        total_ht,
        nbre_commande
      ]
    }

    filter: date_filter {                 ### Choisir la période qu'on souhaite obtenir les résultats###
      label: "Période n"
      type: date
      view_label: "Période"
      group_label: "Année N"
    }

    filter: date_filter_1 {               ### Choisir la période qu'on souhaite obtenir les résultats###
      label: "Période n-1"
      type: date
      view_label: "Période"
      group_label: "Année N-1"
    }

  filter: date_filter_2 {               ### Choisir la période qu'on souhaite obtenir les résultats###
    label: "Période n-2"
    type: date
    view_label: "Période"
    group_label: "Année N-2"
  }

  filter: date_filter_3 {               ### Choisir la période qu'on souhaite obtenir les résultats###
    label: "Période n-3"
    type: date
    view_label: "Période"
    group_label: "Année N-3"
  }

    dimension: categorie {
      hidden: no
      label: "Catégorie"
      sql:
        CASE
          WHEN ${typ} = "S"  OR
          ${dte_ouverture_date} > CAST ({% date_start date_filter_3 %} AS DATETIME) THEN "P. non Comparable"
          WHEN ${dte_ouverture_date} <= CAST ({% date_start date_filter_3 %} AS DATETIME) THEN "P.Comparable"
        END
    ;;
      view_label: "Magasins (actuel)"
    }

  dimension: categorie_histo {
    hidden: no
    label: "Catégorie (histo)"
    sql:
        CASE
          WHEN ${typ} = "S"  OR
          ${dte_ouverture_histo_date} > CAST ({% date_start date_filter_3 %} AS DATETIME) THEN "P. non Comparable"
          WHEN ${dte_ouverture_histo_date} <= CAST ({% date_start date_filter_3 %} AS DATETIME) THEN "P.Comparable"
        END
    ;;
    view_label: "Magasins (à date de vente)"
  }


    dimension: Type_retrocession {
      sql: CASE
            WHEN ${typ_vente} = 0 THEN "Hors rétrocession"
            ELSE "Rétrocession"
          END ;;
      view_label: "Ventes"
    }


  dimension: Groupe_Region {
    sql: CASE
            WHEN ${region} IN ("RN","RNE", "RNW", "RRA", "RSE", "RSW") THEN "France Metro"
            WHEN ${region} IN ("BE", "CAM", "ESP", "IT", "MAL", "MAU", "TOM", "TUN") THEN "International"
          END ;;
    label : "Groupe Région"
    view_label: "Magasins (actuel)"
  }

  dimension: Latitude {
    type: string
    sql: ${TABLE}.Latitude ;;
    label : "Latitude"
    view_label: "Magasins (actuel)"
  }

  dimension: Longitude {
    type: string
    sql: ${TABLE}.Longitude ;;
    label : "Longitude"
    view_label: "Magasins (actuel)"
  }

  dimension: Emplacement {
    type: location
    sql_latitude:${Latitude} ;;
    sql_longitude:${Longitude} ;;
    label : "Emplacement"
    view_label: "Magasins (actuel)"
  }


  dimension: Groupe_Region_histo {
    sql: CASE
            WHEN ${region_histo} IN ("RN","RNE", "RNW", "RRA", "RSE", "RSW") THEN "France Metro"
            WHEN ${region_histo} IN ("BE", "CAM", "ESP", "IT", "MAL", "MAU", "TOM", "TUN") THEN "International"
          END ;;
    label : "Groupe Région (histo)"
    view_label: "Magasins (à date de vente)"
  }

  dimension: Latitude_histo {
    type: string
    sql: ${TABLE}.Latitude_histo ;;
    label : "Latitude (histo)"
    view_label: "Magasins (à date de vente)"
  }

  dimension: Longitude_histo {
    type: string
    sql: ${TABLE}.Longitude_histo ;;
    label : "Longitude (histo)"
    view_label: "Magasins (à date de vente)"
  }

  dimension: Emplacement_histo {
    type: location
    sql_latitude:${Latitude_histo} ;;
    sql_longitude:${Longitude_histo} ;;
    label : "Emplacement (histo)"
    view_label: "Magasins (à date de vente)"
  }


########################## Calcul global des KPIs ################################

    measure: sum_ca_ht {
      type: sum
      value_format_name: eur
      sql: ${ca_ht} ;;
      view_label: "Ventes"
    }

    measure: count_dte_vente {
      hidden: yes
      value_format_name: decimal_0
      type: count_distinct
      sql: ${TABLE}.dte_vente ;;
      view_label: "Ventes"
    }

    dimension: tot_tx_marge_brute {
      type: number
      value_format_name: percent_2
      sql:  1.0 * ${marge_brute}/NULLIF(${ca_ht},0) ;;
      view_label: "Ventes"
    }

    measure: sum_marge_brute {
      hidden: yes
      value_format_name: eur
      type: sum
      sql: ${marge_brute} ;;
      view_label: "Ventes"
    }

    measure: sum_nb_ticket {
      hidden: yes
      value_format_name: decimal_0
      type: sum
      sql: ${nb_ticket} ;;
      view_label: "Ventes"
    }

    measure: sum_qtite {
      hidden: yes
      value_format_name: decimal_0
      type: sum
      sql: ${qtite};;
      view_label: "Ventes"
    }

    measure: sum_val_achat_gbl {
      hidden: yes
      value_format_name: eur
      type: sum
      sql: ${val_achat_gbl} ;;
      view_label: "Ventes"
    }


    ############## calcul des KPIs à la période sélectionnée au niveau du filtre  ############

    measure: sum_CA_select_mois {
      type: sum
      value_format_name: eur
      label: "CA HT"
      sql: CASE
            WHEN {% condition date_filter %} CAST(${dte_vte_date} AS TIMESTAMP)  {% endcondition %}
            THEN ${ca_ht}
          END ;;
      view_label: "Ventes"
      group_label: "Année N"
    }

    measure: sum_marge_select_mois {
      label: "Marge"
      type: sum
      value_format_name: eur
      sql: CASE
            WHEN {% condition date_filter %} CAST(${dte_vte_date} AS TIMESTAMP)  {% endcondition %}
            THEN ${marge_brute}
          END ;;
      view_label: "Ventes"
      group_label: "Année N"
    }

    measure: sum_nb_ticket_select_mois {
      label: "Nb clts"
      type: sum
      value_format_name: decimal_0
      sql: CASE
            WHEN {% condition date_filter %} CAST(${dte_vte_date} AS TIMESTAMP)  {% endcondition %}
            THEN ${nb_ticket}
          END ;;
      view_label: "Clients"
      group_label: "Année N"
    }

    measure: sum_nb_jour_select_mois {
      label: "Nb jr"
      type: count_distinct
      value_format_name: decimal_0
      sql: CASE
            WHEN {% condition date_filter %} CAST(${dte_vte_date} AS TIMESTAMP)  {% endcondition %}
            THEN ${dte_vte_date}
          END ;;
      view_label: "Ventes"
      group_label: "Année N"
    }

    measure: sum_val_achat_gbl_select_mois {
      hidden: yes
      type: sum
      value_format_name: eur
      sql: CASE
            WHEN {% condition date_filter %} CAST(${dte_vte_date} AS TIMESTAMP)  {% endcondition %}
            THEN ${val_achat_gbl}
          END ;;
      view_label: "Ventes"
      group_label: "Année N"
    }


  measure: sum_livraison_select_mois {
    type: sum
    value_format_name: eur
    sql: CASE
            WHEN {% condition date_filter %} CAST(${dte_vte_date} AS TIMESTAMP)  {% endcondition %}
            THEN ${tarif_ht_livraison}
          END ;;
    view_label: "Web"
    group_label: "Année N"
  }

    measure: sum_total_ht_select_mois {
      type: sum
      value_format_name: eur
      sql: CASE
            WHEN {% condition date_filter %} CAST(${dte_vte_date} AS TIMESTAMP)  {% endcondition %}
            THEN ${total_ht}
          END ;;
      view_label: "Web"
      group_label: "Année N"
    }

  measure: sum_CA_drive_select_mois {
    type: number
    value_format_name: eur
    label: "CA Drive"
    sql: ${sum_total_ht_select_mois} + ${sum_livraison_select_mois} ;;
    view_label: "Web"
    group_label: "Année N"
  }

    measure: sum_Nb_cde_drive_select_mois {
      type: sum
      value_format_name: decimal_0
      label: "Commande Drive"
      sql: CASE
            WHEN {% condition date_filter %} CAST(${dte_vte_date} AS TIMESTAMP)  {% endcondition %}
            THEN ${nbre_commande}
          END ;;
      view_label: "Web"
      group_label: "Année N"
    }

    measure: sum_surf_select_mois {
      type: average
      sql: ${surface};;
      view_label: "Ventes"
      group_label: "Année N"
    }

    measure: ecarts_jour_select_mois {
      label: "écart jr"
      type: number
      sql:  ${sum_nb_jour_select_mois}-${sum_nb_jour_select_mois_N1} ;;
      view_label: "Ventes"
      group_label: "Année N"
    }


    ############ calcul des KPIs à n-1 de la période sélectionnée au niveau du filtre ###############



    measure: sum_CA_select_mois_N1 {
      label: "CA HT n-1"
      type: sum
      value_format_name: eur
      sql: CASE
            WHEN {% condition date_filter_1 %} CAST(${dte_vte_date} AS TIMESTAMP)  {% endcondition %}
            THEN ${ca_ht}
          END ;;
      view_label: "Ventes"
      group_label: "Année N-1"
    }

    measure: sum_marge_select_mois_N1 {
      hidden: no
      label: "Marge n-1"
      type: sum
      value_format_name: eur
      sql: CASE
            WHEN {% condition date_filter_1 %} CAST(${dte_vte_date} AS TIMESTAMP)  {% endcondition %}
            THEN ${marge_brute}
          END ;;
      view_label: "Ventes"
      group_label: "Année N-1"
    }

    measure: sum_nb_ticket_select_mois_N1 {
      hidden: no
      label: "Nb clts n-1"
      type: sum
      value_format_name: decimal_0
      sql: CASE
            WHEN {% condition date_filter_1 %} CAST(${dte_vte_date} AS TIMESTAMP)  {% endcondition %}
            THEN ${nb_ticket}
          END ;;
      view_label: "Clients"
      group_label: "Année N-1"
    }

    measure: sum_nb_jour_select_mois_N1 {
      hidden: no
      label: "Nb jr n-1"
      type: count_distinct
      value_format_name: decimal_0
      sql: CASE
            WHEN {% condition date_filter_1 %} CAST(${dte_vte_date} AS TIMESTAMP)  {% endcondition %}
            THEN ${dte_vte_date}
          END ;;
      view_label: "Ventes"
      group_label: "Année N-1"
    }

    measure: sum_val_achat_gbl_select_mois_N1 {
      hidden: yes
      type: sum
      value_format_name: eur
      sql: CASE
            WHEN {% condition date_filter_1 %} CAST(${dte_vte_date} AS TIMESTAMP)  {% endcondition %}
            THEN ${val_achat_gbl}
          END ;;
      view_label: "Ventes"
      group_label: "Année N-1"
    }


  measure: sum_livraison_select_mois_N1 {
    type: sum
    value_format_name: eur
    sql: CASE
            WHEN {% condition date_filter_1 %} CAST(${dte_vte_date} AS TIMESTAMP)   {% endcondition %}
            THEN ${tarif_ht_livraison}
          END ;;
    view_label: "Web"
    group_label: "Année N-1"
  }


  measure: sum_total_ht_select_mois_N1 {
    type: sum
    value_format_name: eur
    sql: CASE
            WHEN {% condition date_filter_1 %} CAST(${dte_vte_date} AS TIMESTAMP)   {% endcondition %}
            THEN ${total_ht}
          END ;;
    view_label: "Web"
    group_label: "Année N-1"
  }

    measure: sum_CA_drive_select_mois_N1 {
      type: number
      value_format_name: eur
      label: "CA Drive n-1"
      sql: ${sum_total_ht_select_mois_N1} + ${sum_livraison_select_mois_N1} ;;
      view_label: "Web"
      group_label: "Année N-1"
    }

    measure: sum_Nb_cde_drive_select_mois_N1 {
      type: sum
      value_format_name: decimal_0
      label: "Commande Drive n-1"
      sql: CASE
            WHEN {% condition date_filter_1 %} CAST(${dte_vte_date} AS TIMESTAMP)  {% endcondition %}
            THEN ${nbre_commande}
          END ;;
      view_label: "Web"
      group_label: "Année N-1"
    }

    ############## calcul des KPIs à n-2 de la période sélectionnée au niveau du filtre ##############


    measure: sum_CA_select_mois_N2 {
      hidden: no
      label: "CA HT n-2"
      type: sum
      value_format_name: eur
      sql: CASE
            WHEN {% condition date_filter_2 %} CAST(${dte_vte_date} AS TIMESTAMP)  {% endcondition %}
            THEN ${ca_ht}
          END ;;
      view_label: "Ventes"
      group_label: "Année N-2"
    }

    measure: sum_marge_select_mois_N2 {
      hidden: no
      label: "Marge n-2"
      type: sum
      value_format_name: eur
      sql: CASE
            WHEN {% condition date_filter_2 %} CAST(${dte_vte_date} AS TIMESTAMP)  {% endcondition %}
            THEN ${marge_brute}
          END ;;
      view_label: "Ventes"
      group_label: "Année N-2"
    }

    measure: sum_nb_ticket_select_mois_N2 {
      hidden: no
      label: "Nb clts n-2"
      type: sum
      value_format_name: decimal_0
      sql: CASE
           WHEN {% condition date_filter_2 %} CAST(${dte_vte_date} AS TIMESTAMP)  {% endcondition %}
            THEN ${nb_ticket}
          END ;;
      view_label: "Clients"
      group_label: "Année N-2"
    }

    measure: sum_nb_jour_select_mois_N2 {
      hidden: no
      label: "Nb jr n-2"
      type: count_distinct
      value_format_name: decimal_0
      sql: CASE
            WHEN {% condition date_filter_2 %} CAST(${dte_vte_date} AS TIMESTAMP)  {% endcondition %}
            THEN ${dte_vte_date}
          END ;;
      view_label: "Ventes"
      group_label: "Année N-2"
    }

    measure: sum_val_achat_gbl_select_mois_N2 {
      hidden: yes
      type: sum
      value_format_name: eur
      sql: CASE
            WHEN {% condition date_filter_2 %} CAST(${dte_vte_date} AS TIMESTAMP)  {% endcondition %}
            THEN ${val_achat_gbl}
          END ;;
      view_label: "Ventes"
      group_label: "Année N-2"
    }

  measure: sum_livraison_select_mois_N2 {
    type: sum
    value_format_name: eur
    sql: CASE
            WHEN {% condition date_filter_2 %} CAST(${dte_vte_date} AS TIMESTAMP)  {% endcondition %}
            THEN ${tarif_ht_livraison}
          END ;;
    view_label: "Web"
    group_label: "Année N-2"
  }

  measure: sum_total_ht_select_mois_N2 {
    type: sum
    value_format_name: eur
    sql: CASE
            WHEN {% condition date_filter_2 %} CAST(${dte_vte_date} AS TIMESTAMP)  {% endcondition %}
            THEN ${total_ht}
          END ;;
    view_label: "Web"
    group_label: "Année N-2"
  }

    measure: sum_CA_drive_select_mois_N2 {
      hidden: no
      type: number
      value_format_name: eur
      label: "CA Drive n-2"
      sql: ${sum_total_ht_select_mois_N2} + ${sum_livraison_select_mois_N2} ;;
      view_label: "Web"
      group_label: "Année N-2"
    }

    measure: sum_Nb_cde_drive_select_mois_N2 {
      hidden: no
      type: sum
      value_format_name: decimal_0
      label: "Commande Drive n-2"
      sql: CASE
            WHEN {% condition date_filter_2 %} CAST(${dte_vte_date} AS TIMESTAMP)   {% endcondition %}
            THEN ${nbre_commande}
          END ;;
      view_label: "Web"
      group_label: "Année N-2"
    }


    ############ calcul des KPIs à n-3 de la période sélectionnée au niveau du filtre ###############


    measure: sum_CA_select_mois_N3 {
      hidden: no
      label: "CA HT n-3"
      type: sum
      value_format_name: eur
      sql: CASE
            WHEN {% condition date_filter_3 %} CAST(${dte_vte_date} AS TIMESTAMP)  {% endcondition %}
            THEN ${ca_ht}
          END ;;
      view_label: "Ventes"
      group_label: "Année N-3"
    }

    measure: sum_marge_select_mois_N3 {
      hidden: no
      label: "Marge n-3"
      type: sum
      value_format_name: eur
      sql: CASE
            WHEN {% condition date_filter_3 %} CAST(${dte_vte_date} AS TIMESTAMP)  {% endcondition %}
            THEN ${marge_brute}
          END ;;
      view_label: "Ventes"
      group_label: "Année N-3"
    }

    measure: sum_nb_ticket_select_mois_N3 {
      hidden: no
      label: "Nb clts n-3"
      type: sum
      value_format_name: decimal_0
      sql: CASE
            WHEN {% condition date_filter_3 %} CAST(${dte_vte_date} AS TIMESTAMP)  {% endcondition %}
            THEN ${nb_ticket}
          END ;;
      view_label: "Clients"
      group_label: "Année N-3"
    }

    measure: sum_nb_jour_select_mois_N3 {
      hidden: yes
      label: "Nb jr n-3"
      type: count_distinct
      value_format_name: decimal_0
      sql: CASE
            WHEN {% condition date_filter_3 %} CAST(${dte_vte_date} AS TIMESTAMP)  {% endcondition %}
            THEN ${dte_vte_date}
          END ;;
      view_label: "Ventes"
      group_label: "Année N-3"
    }

    measure: sum_val_achat_gbl_select_mois_N3 {
      hidden: yes
      type: sum
      value_format_name: eur
      sql: CASE
            WHEN {% condition date_filter_3 %} CAST(${dte_vte_date} AS TIMESTAMP)  {% endcondition %}
            THEN ${val_achat_gbl}
          END ;;
      view_label: "Ventes"
      group_label: "Année N-3"
    }


    ######### calcul des rapports entre les KPIs à la période n sélectionnée au niveau du filtre  ##########


    measure: client_par_jour_select_mois {
      label: "clts / jour"
      value_format_name: decimal_0
      type: number
      sql: ${sum_nb_ticket_select_mois}/NULLIF(${sum_nb_jour_select_mois},0) ;;
      view_label: "Clients"
      group_label: "Année N"
    }

    measure: ca_par_jour_select_mois {
      label: "CA / jour"
      value_format_name: eur
      type: number
      sql:  ${sum_CA_select_mois}/NULLIF(${sum_nb_jour_select_mois},0) ;;
      view_label: "Ventes"
      group_label: "Année N"
    }

    measure: ca_par_m_carre_select_mois {
      label: "CA / m²"
      value_format_name: eur
      type: number
      sql:  ${sum_CA_select_mois}/NULLIF(${sum_surf_select_mois},0) ;;
      view_label: "Ventes"
      group_label: "Année N"
    }

    measure: taux_de_marge_select_mois {
      label: "% marge"
      value_format_name: percent_2
      type: number
      sql: 1.0 * ${sum_marge_select_mois}/NULLIF(${sum_CA_select_mois},0);;
      view_label: "Ventes"
      group_label: "Année N"
    }

    measure: panier_moyen_select_mois {
      label: "PM"
      value_format_name: decimal_2
      type: number
      sql:  ${sum_CA_select_mois}/NULLIF(${sum_nb_ticket_select_mois},0) ;;
      view_label: "Panier Moyen"
      group_label: "Année N"
    }

    measure: panier_moyen_drive_select_mois {
      label: "PM Drive"
      value_format_name: decimal_2
      type: number
      sql:  ${sum_CA_drive_select_mois}/NULLIF(${sum_Nb_cde_drive_select_mois},0) ;;
      view_label: "Panier Moyen"
      group_label: "Année N"
    }

    measure: marge_par_client_select_mois {
      label: "marge / clts"
      value_format_name: decimal_2
      type: number
      sql: ${sum_marge_select_mois}/NULLIF(${sum_nb_ticket_select_mois},0) ;;
      view_label: "Ventes"
      group_label: "Année N"
    }


    ######### calcul des rapports entre les KPIs à la période n-1 sélectionnée au niveau du filtre  ##########

    measure: client_par_jour_select_mois_N1 {
      label: "clts/jr n-1"
      value_format_name: decimal_0
      type: number
      sql: ${sum_nb_ticket_select_mois_N1}/NULLIF(${sum_nb_jour_select_mois_N1},0) ;;
      drill_fields: [detail*]
      view_label: "Clients"
      group_label: "Année N-1"
    }

    measure: ca_par_jour_select_mois_N1 {
      hidden: no
      label: "CA/jr n-1"
      value_format_name: eur
      type: number
      sql:  ${sum_CA_select_mois_N1}/NULLIF(${sum_nb_jour_select_mois_N1},0) ;;
      view_label: "Ventes"
      group_label: "Année N-1"
    }

    measure: ca_par_m_carre_select_mois_N1 {
      label: "CA/m² n-1"
      value_format_name: eur
      type: number
      sql:  ${sum_CA_select_mois_N1}/NULLIF(${sum_surf_select_mois},0) ;;
      view_label: "Ventes"
      group_label: "Année N-1"
    }

    measure: taux_de_marge_select_mois_N1 {
      hidden: no
      label: "% marge n-1"
      value_format_name: percent_2
      type: number
      sql: 1.0 * ${sum_marge_select_mois_N1}/NULLIF(${sum_CA_select_mois_N1},0);;
      view_label: "Ventes"
      group_label: "Année N-1"
    }

    measure: panier_moyen_select_mois_N1 {
      hidden: no
      label: "PM n-1"
      value_format_name: decimal_2
      type: number
      sql:  ${sum_CA_select_mois_N1}/NULLIF(${sum_nb_ticket_select_mois_N1},0) ;;
      view_label: "Panier Moyen"
      group_label: "Année N-1"
    }

    measure: marge_par_client_select_mois_N1 {
      label: "marge/clts n-1"
      value_format_name: decimal_2
      type: number
      sql: ${sum_marge_select_mois_N1}/NULLIF(${sum_nb_ticket_select_mois_N1},0) ;;
      view_label: "Ventes"
      group_label: "Année N-1"
    }



    ######### calcul des rapports entre les KPIs à la période n-2 sélectionnée au niveau du filtre  ##########


    measure: client_par_jour_select_mois_N2 {
      hidden: no
      label: "clts/jr n-2"
      value_format_name: decimal_0
      type: number
      sql: ${sum_nb_ticket_select_mois_N2}/NULLIF(${sum_nb_jour_select_mois_N2},0) ;;
      view_label: "Clients"
      group_label: "Année N-2"
    }

    measure: ca_par_jour_select_mois_N2 {
      hidden: no
      label: "CA/jr n-2"
      value_format_name: eur
      type: number
      sql:  ${sum_CA_select_mois_N2}/NULLIF(${sum_nb_jour_select_mois_N2},0) ;;
      view_label: "Ventes"
      group_label: "Année N-2"
    }

    measure: ca_par_m_carre_select_mois_N2 {
      hidden: no
      label: "CA/m² n-2"
      value_format_name: eur
      type: number
      sql:  ${sum_CA_select_mois_N2}/NULLIF(${sum_surf_select_mois},0) ;;
      view_label: "Ventes"
      group_label: "Année N-2"
    }

    measure: taux_de_marge_select_mois_N2 {
      hidden: no
      label: "% marge n-2"
      value_format_name: percent_2
      type: number
      sql: 1.0 * ${sum_marge_select_mois_N2}/NULLIF(${sum_CA_select_mois_N2},0);;
      view_label: "Ventes"
      group_label: "Année N-2"
    }

    measure: panier_moyen_select_mois_N2 {
      hidden: no
      label: "PM n-2"
      value_format_name: decimal_2
      type: number
      sql:  ${sum_CA_select_mois_N2}/NULLIF(${sum_nb_ticket_select_mois_N2},0) ;;
      view_label: "Panier Moyen"
      group_label: "Année N-2"
    }

    measure: marge_par_client_select_mois_N2 {
      hidden: no
      label: "marge/clts n-2"
      value_format_name: decimal_2
      type: number
      sql: ${sum_marge_select_mois_N2}/NULLIF(${sum_nb_ticket_select_mois_N2},0) ;;
      view_label: "Ventes"
      group_label: "Année N-2"
    }



    ######### calcul des rapports entre les KPIs à la période n-3 sélectionnée au niveau du filtre  ##########


    measure: client_par_jour_select_mois_N3 {
      hidden: no
      label: "clts/jr n-3"
      value_format_name: decimal_0
      type: number
      sql: ${sum_nb_ticket_select_mois_N3}/NULLIF(${sum_nb_jour_select_mois_N3},0) ;;
      view_label: "Clients"
      group_label: "Année N-3"
    }

    measure: ca_par_jour_select_mois_N3 {
      hidden: no
      label: "CA/jr n-3"
      value_format_name: eur
      type: number
      sql:  ${sum_CA_select_mois_N3}/NULLIF(${sum_nb_jour_select_mois_N3},0) ;;
      view_label: "Ventes"
      group_label: "Année N-3"
    }

    measure: ca_par_m_carre_select_mois_N3 {
      hidden: no
      label: "CA/m² n-3"
      value_format_name: eur
      type: number
      sql:  ${sum_CA_select_mois_N3}/NULLIF(${sum_surf_select_mois},0) ;;
      view_label: "Ventes"
      group_label: "Année N-3"
    }

    measure: taux_de_marge_select_mois_N3 {
      hidden: no
      label: "% marge n-3"
      value_format_name: percent_2
      type: number
      sql: 1.0 * ${sum_marge_select_mois_N3}/NULLIF(${sum_CA_select_mois_N3},0);;
      view_label: "Ventes"
      group_label: "Année N-3"
    }

    measure: panier_moyen_select_mois_N3 {
      hidden: no
      label: "PM n-3"
      value_format_name: decimal_2
      type: number
      sql:  ${sum_CA_select_mois_N3}/NULLIF(${sum_nb_ticket_select_mois_N3},0) ;;
      view_label: "Panier Moyen"
      group_label: "Année N-3"
    }

    measure: marge_par_client_select_mois_N3 {
      hidden: no
      label: "marge/clts n-3"
      value_format_name: decimal_2
      type: number
      sql: ${sum_marge_select_mois_N3}/NULLIF(${sum_nb_ticket_select_mois_N3},0) ;;
      view_label: "Ventes"
      group_label: "Année N-3"
    }


    ########### Calcul des progressions n vs n-1 à la péridode sélectionée au niveau du filtre ###########


    measure: prog_CA_select_mois {
      label: "prog CA"
      value_format_name: percent_2
      type: number
      sql: 1.0 * (${sum_CA_select_mois}-${sum_CA_select_mois_N1})/NULLIF(${sum_CA_select_mois_N1},0);;
      view_label: "Ventes"
      group_label: "Année N"
    }

    measure: prog_CA_Drive_select_mois {
      label: "prog CA Drive"
      value_format_name: percent_2
      type: number
      sql: 1.0 * (${sum_CA_drive_select_mois}-${sum_CA_drive_select_mois_N1})/NULLIF(${sum_CA_drive_select_mois_N1},0);;
      view_label: "Ventes"
      group_label: "Année N"
    }

    measure: prog_marge_select_mois {
      label: "prog marge"
      value_format_name: percent_2
      type: number
      sql:  1.0 * (${sum_marge_select_mois}-${sum_marge_select_mois_N1})/NULLIF(${sum_marge_select_mois_N1},0);;
      view_label: "Ventes"
      group_label: "Année N"
    }

    measure: prog_taux_marge_select_mois {
      label: "prog %marge"
      value_format_name: percent_2
      type: number
      sql:  1.0 * (${taux_de_marge_select_mois}-${taux_de_marge_select_mois_N1})/NULLIF(${taux_de_marge_select_mois_N1},0);;
      view_label: "Ventes"
      group_label: "Année N"
    }

    measure: prog_ca_par_m_carre_select_mois {
      label: "prog CA/m²"
      value_format_name: percent_2
      type: number
      sql:  1.0 * (${ca_par_m_carre_select_mois}-${ca_par_m_carre_select_mois_N1})/NULLIF(${ca_par_m_carre_select_mois_N1},0);;
      view_label: "Ventes"
      group_label: "Année N"
    }

    measure: prog_Clients_select_mois {
      label: "prog clts/jr"
      value_format_name: percent_2
      type: number
      sql: 1.0 * (${client_par_jour_select_mois}-${client_par_jour_select_mois_N1})/NULLIF(${client_par_jour_select_mois_N1},0) ;;
      view_label: "Clients"
      group_label: "Année N"
    }

    measure: prog_nb_Clients_select_mois {
      label: "prog nb clts"
      value_format_name: percent_2
      type: number
      sql: 1.0 * (${sum_nb_ticket_select_mois}-${sum_nb_ticket_select_mois_N1})/NULLIF(${sum_nb_ticket_select_mois_N1},0) ;;
      view_label: "Clients"
      group_label: "Année N"
    }

    measure: prog_ca_jour_select_mois {
      label: "prog CA / jr"
      value_format_name: percent_2
      type: number
      sql: 1.0 * (${ca_par_jour_select_mois}-${ca_par_jour_select_mois_N1})/NULLIF(${ca_par_jour_select_mois_N1},0) ;;
      view_label: "Ventes"
      group_label: "Année N"
    }

    measure: prog_PM_select_mois {
      label: "prog PM"
      value_format_name: percent_2
      type: number
      sql: 1.0 * (${panier_moyen_select_mois}-${panier_moyen_select_mois_N1})/(NULLIF(${panier_moyen_select_mois_N1},0));;
      view_label: "Panier Moyen"
      group_label: "Année N"
    }

    measure: prog_marge_client_select_mois {
      label: "prog marge/clt"
      value_format_name: percent_2
      type: number
      sql: 1.0 * (${marge_par_client_select_mois}-${marge_par_client_select_mois_N1})/NULLIF(${marge_par_client_select_mois_N1},0);;
      view_label: "Ventes"
      group_label: "Année N"
    }



    ######### Calcul des progressions n-1 vs n-2 à la péridode sélectionée au niveau du filtre #########

    measure:prog_ca_select_mois_N1 {
      label: "prog CA n-1"
      value_format_name: percent_2
      type: number
      sql: 1.0 * (${sum_CA_select_mois_N1}-${sum_CA_select_mois_N2})/NULLIF(${sum_CA_select_mois_N2},0);;
      view_label: "Ventes"
      group_label: "Année N-1"
    }

    measure: prog_marge_select_mois_N1 {
      hidden: no
      label: "prog marge n-1"
      value_format_name: percent_2
      type: number
      sql:  1.0 * (${sum_marge_select_mois_N1}-${sum_marge_select_mois_N2})/NULLIF(${sum_marge_select_mois_N2},0);;
      view_label: "Ventes"
      group_label: "Année N-1"
    }

    measure: prog_ca_par_m_carre_select_mois_N1 {
      hidden: no
      label: "prog CA/m² n-1"
      value_format_name: percent_2
      type: number
      sql:  1.0 * (${ca_par_m_carre_select_mois_N1}-${ca_par_m_carre_select_mois_N2})/NULLIF(${ca_par_m_carre_select_mois_N2},0);;
      view_label: "Ventes"
      group_label: "Année N-1"
    }

    measure: prog_nb_Clients_select_mois_N1 {
      hidden: no
      label: "prog nb clts n-1"
      value_format_name: percent_2
      type: number
      sql: 1.0 * (${sum_nb_ticket_select_mois_N1}-${sum_nb_ticket_select_mois_N2})/NULLIF(${sum_nb_ticket_select_mois_N2},0) ;;
      view_label: "Clients"
      group_label: "Année N-1"
    }

    measure: prog_taux_marge_select_mois_N1 {
      hidden: no
      label: "prog %marge n-1"
      value_format_name: percent_2
      type: number
      sql:  1.0 * (${taux_de_marge_select_mois_N1}-${taux_de_marge_select_mois_N2})/NULLIF(${taux_de_marge_select_mois_N2},0);;
      view_label: "Ventes"
      group_label: "Année N-1"
    }

    measure: prog_Clients_select_mois_N1 {
      hidden: no
      label: "prog clts/jr n-1"
      value_format_name: percent_2
      type: number
      sql: 1.0 * (${client_par_jour_select_mois_N1}-${client_par_jour_select_mois_N2})/NULLIF(${client_par_jour_select_mois_N2},0) ;;
      view_label: "Clients"
      group_label: "Année N-1"
    }

    measure: prog_ca_jour_select_mois_N1 {
      hidden: no
      label: "prog CA/jr n-1"
      value_format_name: percent_2
      type: number
      sql: 1.0 * (${ca_par_jour_select_mois_N1}-${ca_par_jour_select_mois_N2})/NULLIF(${ca_par_jour_select_mois_N2},0) ;;
      view_label: "Ventes"
      group_label: "Année N-1"
    }

    measure: prog_PM_select_mois_N1 {
      hidden: no
      label: "prog PM n-1"
      value_format_name: percent_2
      type: number
      sql: 1.0 * (${panier_moyen_select_mois_N1}-${panier_moyen_select_mois_N2})/(NULLIF(${panier_moyen_select_mois_N2},0));;
      view_label: "Panier Moyen"
      group_label: "Année N-1"
    }

    measure: prog_marge_client_select_mois_N1 {
      hidden: no
      label: "prog marge/clt n-1"
      value_format_name: percent_2
      type: number
      sql: 1.0 * (${marge_par_client_select_mois_N1}-${marge_par_client_select_mois_N2})/NULLIF(${marge_par_client_select_mois_N2},0);;
      view_label: "Ventes"
      group_label: "Année N-1"
    }


    ######### Calcul des progressions n-2 vs n-3 à la péridode sélectionée au niveau du filtre #########

    measure:prog_ca_select_mois_N2 {
      hidden: no
      label: "prog CA n-2"
      value_format_name: percent_2
      type: number
      sql: 1.0 * (${sum_CA_select_mois_N2}-${sum_CA_select_mois_N3})/NULLIF(${sum_CA_select_mois_N3},0);;
      view_label: "Ventes"
      group_label: "Année N-2"
    }

    measure: prog_marge_select_mois_N2 {
      hidden: no
      label: "prog marge n-2"
      value_format_name: percent_2
      type: number
      sql:  1.0 * (${sum_marge_select_mois_N2}-${sum_marge_select_mois_N3})/NULLIF(${sum_marge_select_mois_N3},0);;
      view_label: "Ventes"
      group_label: "Année N-2"
    }

    measure: prog_ca_par_m_carre_select_mois_N2 {
      hidden: no
      label: "prog CA/m² n-2"
      value_format_name: percent_2
      type: number
      sql:  1.0 * (${ca_par_m_carre_select_mois_N2}-${ca_par_m_carre_select_mois_N3})/NULLIF(${ca_par_m_carre_select_mois_N3},0);;
      view_label: "Ventes"
      group_label: "Année N-2"
    }

    measure: prog_taux_marge_select_mois_N2 {
      hidden: no
      label: "prog %marge n-2"
      value_format_name: percent_2
      type: number
      sql:  1.0 * (${taux_de_marge_select_mois_N2}-${taux_de_marge_select_mois_N3})/NULLIF(${taux_de_marge_select_mois_N3},0);;
      view_label: "Ventes"
      group_label: "Année N-2"
    }

    measure: prog_Clients_select_mois_N2 {
      hidden: no
      label: "prog clts/jr n-2"
      value_format_name: percent_2
      type: number
      sql: 1.0 * (${client_par_jour_select_mois_N2}-${client_par_jour_select_mois_N3})/NULLIF(${client_par_jour_select_mois_N3},0) ;;
      view_label: "Clients"
      group_label: "Année N-2"
    }

    measure: prog_nb_Clients_select_mois_N2 {
      hidden: no
      label: "prog nb clts n-2"
      value_format_name: percent_2
      type: number
      sql: 1.0 * (${sum_nb_ticket_select_mois_N2}-${sum_nb_ticket_select_mois_N3})/NULLIF(${sum_nb_ticket_select_mois_N3},0) ;;
      view_label: "Clients"
      group_label: "Année N-2"
    }

    measure: prog_ca_jour_select_mois_N2 {
      hidden: no
      label: "prog CA/jr n-2"
      value_format_name: percent_2
      type: number
      sql: 1.0 * (${ca_par_jour_select_mois_N2}-${ca_par_jour_select_mois_N3})/NULLIF(${ca_par_jour_select_mois_N3},0) ;;
      view_label: "Ventes"
      group_label: "Année N-2"
    }

    measure: prog_PM_select_mois_N2 {
      hidden: no
      label: "prog PM n-2"
      value_format_name: percent_2
      type: number
      sql: 1.0 * (${panier_moyen_select_mois_N2}-${panier_moyen_select_mois_N3})/(NULLIF(${panier_moyen_select_mois_N3},0));;
      view_label: "Panier Moyen"
      group_label: "Année N-2"
    }

    measure: prog_marge_client_select_mois_N2 {
      hidden: no
      label: "prog marge/clt n-2"
      value_format_name: percent_2
      type: number
      sql: 1.0 * (${marge_par_client_select_mois_N2}-${marge_par_client_select_mois_N3})/NULLIF(${marge_par_client_select_mois_N3},0);;
      view_label: "Ventes"
      group_label: "Année N-2"
    }

  }
