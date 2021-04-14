view: tbe_table {
  sql_table_name: `bv-prod.Matillion_Perm_Table.TBE_TABLE`
    ;;


  dimension: anciennete {
    type: string
    sql: ${TABLE}.Anciennete ;;
  }

  dimension: animateur {
    type: string
    sql: ${TABLE}.Animateur ;;
  }

  dimension: ca_ht {
    type: number
    sql: ${TABLE}.ca_ht ;;
  }

  dimension: cd_magasin {
    type: string
    sql: ${TABLE}.CD_Magasin ;;
  }

  dimension: cd_site_ext {
    type: string
    sql: ${TABLE}.CD_Site_Ext ;;
  }

  dimension: directeur {
    type: string
    sql: ${TABLE}.Directeur ;;
  }

  dimension_group: dte_ouverture {
    type: time
    timeframes: [
      raw,
      date,
      week,
      month,
      quarter,
      year
    ]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.Dte_Ouverture ;;
  }

  dimension_group: dte_vte {
    type: time
    timeframes: [
      raw,
      date,
      week,
      month,
      quarter,
      year
    ]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.Dte_Vte ;;
  }

  dimension: franchise {
    type: string
    sql: ${TABLE}.Franchise ;;
  }

  dimension: marge_brute {
    type: number
    sql: ${TABLE}.marge_brute ;;
  }

  dimension: nb_ticket {
    type: number
    sql: ${TABLE}.nb_ticket ;;
  }

  dimension: nbre_commande {
    type: number
    sql: ${TABLE}.Nbre_commande ;;
  }

  dimension: nom {
    type: string
    sql: ${TABLE}.NOM ;;
  }

  dimension: pays {
    type: string
    sql: ${TABLE}.Pays ;;
  }

  dimension: qtite {
    type: number
    sql: ${TABLE}.Qtite ;;
  }

  dimension: region {
    type: string
    sql: ${TABLE}.Region ;;
  }

  dimension: surface {
    type: number
    sql: ${TABLE}.Surface ;;
  }

  dimension: total_ht {
    type: number
    sql: ${TABLE}.Total_HT ;;
  }

  dimension: typ_mag {
    type: string
    sql: ${TABLE}.TYP_MAG ;;
  }

  dimension: typ_vente {
    type: number
    sql: ${TABLE}.Typ_Vente ;;
  }

  dimension: val_achat_gbl {
    type: number
    sql: ${TABLE}.Val_Achat_Gbl ;;
  }

  filter: date_filter {                 ### Choisir la période qu'on souhaite obtenir les résultats###
    label: "Période n"
    type: date
  }

  filter: date_filter_1 {               ### Choisir la période qu'on souhaite obtenir les résultats###
    label: "Période n-1"
    type: date
  }

  filter: date_filter_2 {               ### Choisir la période qu'on souhaite obtenir les résultats###
    label: "Période n-2"
    type: date
  }

  filter: date_filter_3 {               ### Choisir la période qu'on souhaite obtenir les résultats###
    label: "Période n-3"
    type: date
  }



  # dimension: categorie {
  #   label: "Catégorie"
  #   sql:
  #       CASE
  #         WHEN ${magasins.ferme} = "S" THEN "P. non comparable"
  #         ELSE (
  #           CASE
  #             WHEN ${magasins.date_ouv_date} < CAST ({% date_start date_filter_3 %} AS DATETIME) THEN "P.Comparable"
  #             ELSE "P. non Comparable"
  #           END )
  #       END
  #   ;;
  # }




  dimension: Type_retrocession {
    sql: CASE
            WHEN ${typ_vente} = 0 THEN "Hors rétrocession"
            WHEN ${typ_vente} = 1 THEN "Rétrocession"
          END ;;
  }


########################## Calcul global des KPIs ################################

  measure: sum_ca_ht {
    type: sum
    value_format_name: eur
    sql: ${ca_ht} ;;
  }

  measure: count_dte_vente {
    hidden: yes
    value_format_name: decimal_0
    type: count_distinct
    sql: ${TABLE}.dte_vente ;;
  }

  dimension: tot_tx_marge_brute {
    type: number
    value_format_name: percent_2
    sql:  1.0 * ${marge_brute}/NULLIF(${ca_ht},0) ;;
  }

  measure: sum_marge_brute {
    hidden: yes
    value_format_name: eur
    type: sum
    sql: ${marge_brute} ;;
  }

  measure: sum_nb_ticket {
    hidden: yes
    value_format_name: decimal_0
    type: sum
    sql: ${nb_ticket} ;;
  }

  measure: sum_qtite {
    hidden: yes
    value_format_name: decimal_0
    type: sum
    sql: ${qtite};;
  }

  measure: sum_val_achat_gbl {
    hidden: yes
    value_format_name: eur
    type: sum
    sql: ${val_achat_gbl} ;;
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
  }

  measure: sum_marge_select_mois {
    label: "Marge"
    type: sum
    value_format_name: eur
    sql: CASE
            WHEN {% condition date_filter %} CAST(${dte_vte_date} AS TIMESTAMP)  {% endcondition %}
            THEN ${marge_brute}
          END ;;
  }

  measure: sum_nb_ticket_select_mois {
    label: "Nb clts"
    type: sum
    value_format_name: decimal_0
    sql: CASE
            WHEN {% condition date_filter %} CAST(${dte_vte_date} AS TIMESTAMP)  {% endcondition %}
            THEN ${nb_ticket}
          END ;;
  }

  measure: sum_nb_jour_select_mois {
    label: "Nb jr"
    type: count_distinct
    value_format_name: decimal_0
    sql: CASE
            WHEN {% condition date_filter %} CAST(${dte_vte_date} AS TIMESTAMP)  {% endcondition %}
            THEN ${dte_vte_date}
          END ;;
  }

  measure: sum_val_achat_gbl_select_mois {
    hidden: yes
    type: sum
    value_format_name: eur
    sql: CASE
            WHEN {% condition date_filter %} CAST(${dte_vte_date} AS TIMESTAMP)  {% endcondition %}
            THEN ${val_achat_gbl}
          END ;;
  }

  measure: sum_CA_drive_select_mois {
    type: sum
    value_format_name: eur
    label: "CA Drive"
    sql: CASE
            WHEN {% condition date_filter %} CAST(${dte_vte_date} AS TIMESTAMP)  {% endcondition %}
            THEN ${total_ht}
          END ;;
  }

  measure: sum_Nb_cde_drive_select_mois {
    type: sum
    value_format_name: decimal_0
    label: "Commande Drive"
    sql: CASE
            WHEN {% condition date_filter %} CAST(${dte_vte_date} AS TIMESTAMP)  {% endcondition %}
            THEN ${nbre_commande}
          END ;;
  }

  measure: sum_surf_select_mois {
    type: average
    sql: ${surface};;
  }

  measure: ecarts_jour_select_mois {
    label: "écart jr"
    type: number
    sql:  ${sum_nb_jour_select_mois}-${sum_nb_jour_select_mois_N1} ;;
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
  }

  measure: sum_marge_select_mois_N1 {
    label: "Marge n-1"
    type: sum
    value_format_name: eur
    sql: CASE
            WHEN {% condition date_filter_1 %} CAST(${dte_vte_date} AS TIMESTAMP)  {% endcondition %}
            THEN ${marge_brute}
          END ;;
  }

  measure: sum_nb_ticket_select_mois_N1 {
    label: "Nb clts n-1"
    type: sum
    value_format_name: decimal_0
    sql: CASE
            WHEN {% condition date_filter_1 %} CAST(${dte_vte_date} AS TIMESTAMP)  {% endcondition %}
            THEN ${nb_ticket}
          END ;;
  }

  measure: sum_nb_jour_select_mois_N1 {
    label: "Nb jr n-1"
    type: count_distinct
    value_format_name: decimal_0
    sql: CASE
            WHEN {% condition date_filter_1 %} CAST(${dte_vte_date} AS TIMESTAMP)  {% endcondition %}
            THEN ${dte_vte_date}
          END ;;
  }

  measure: sum_val_achat_gbl_select_mois_N1 {
    hidden: yes
    type: sum
    value_format_name: eur
    sql: CASE
            WHEN {% condition date_filter_1 %} CAST(${dte_vte_date} AS TIMESTAMP)  {% endcondition %}
            THEN ${val_achat_gbl}
          END ;;
  }

  measure: sum_CA_drive_select_mois_N1 {
    type: sum
    value_format_name: eur
    label: "CA Drive n-1"
    sql: CASE
            WHEN {% condition date_filter_1 %} CAST(${dte_vte_date} AS TIMESTAMP)   {% endcondition %}
            THEN ${total_ht}
          END ;;
  }

  measure: sum_Nb_cde_drive_select_mois_N1 {
    type: sum
    value_format_name: decimal_0
    label: "Commande Drive n-1"
    sql: CASE
            WHEN {% condition date_filter_1 %} CAST(${dte_vte_date} AS TIMESTAMP)  {% endcondition %}
            THEN ${nbre_commande}
          END ;;
  }

  ############## calcul des KPIs à n-2 de la période sélectionnée au niveau du filtre ##############


  measure: sum_CA_select_mois_N2 {
    label: "CA HT n-2"
    type: sum
    value_format_name: eur
    sql: CASE
            WHEN {% condition date_filter_2 %} CAST(${dte_vte_date} AS TIMESTAMP)  {% endcondition %}
            THEN ${ca_ht}
          END ;;
  }

  measure: sum_marge_select_mois_N2 {
    label: "Marge n-2"
    type: sum
    value_format_name: eur
    sql: CASE
            WHEN {% condition date_filter_2 %} CAST(${dte_vte_date} AS TIMESTAMP)  {% endcondition %}
            THEN ${marge_brute}
          END ;;
  }

  measure: sum_nb_ticket_select_mois_N2 {
    label: "Nb clts n-2"
    type: sum
    value_format_name: decimal_0
    sql: CASE
           WHEN {% condition date_filter_2 %} CAST(${dte_vte_date} AS TIMESTAMP)  {% endcondition %}
            THEN ${nb_ticket}
          END ;;
  }

  measure: sum_nb_jour_select_mois_N2 {
    hidden: yes
    type: count_distinct
    value_format_name: decimal_0
    sql: CASE
            WHEN {% condition date_filter_2 %} CAST(${dte_vte_date} AS TIMESTAMP)  {% endcondition %}
            THEN ${dte_vte_date}
          END ;;
  }

  measure: sum_val_achat_gbl_select_mois_N2 {
    hidden: yes
    type: sum
    value_format_name: eur
    sql: CASE
            WHEN {% condition date_filter_2 %} CAST(${dte_vte_date} AS TIMESTAMP)  {% endcondition %}
            THEN ${val_achat_gbl}
          END ;;
  }

  measure: sum_CA_drive_select_mois_N2 {
    type: sum
    value_format_name: eur
    label: "CA Drive n-2"
    sql: CASE
            WHEN {% condition date_filter_2 %} CAST(${dte_vte_date} AS TIMESTAMP)  {% endcondition %}
            THEN ${total_ht}
          END ;;
  }

  measure: sum_Nb_cde_drive_select_mois_N2 {
    type: sum
    value_format_name: decimal_0
    label: "Commande Drive n-2"
    sql: CASE
            WHEN {% condition date_filter_2 %} CAST(${dte_vte_date} AS TIMESTAMP)   {% endcondition %}
            THEN ${nbre_commande}
          END ;;
  }


  ############ calcul des KPIs à n-3 de la période sélectionnée au niveau du filtre ###############


  measure: sum_CA_select_mois_N3 {
    label: "CA HT n-3"
    type: sum
    value_format_name: eur
    sql: CASE
            WHEN {% condition date_filter_3 %} CAST(${dte_vte_date} AS TIMESTAMP)  {% endcondition %}
            THEN ${ca_ht}
          END ;;
  }

  measure: sum_marge_select_mois_N3 {
    label: "Marge n-3"
    type: sum
    value_format_name: eur
    sql: CASE
            WHEN {% condition date_filter_3 %} CAST(${dte_vte_date} AS TIMESTAMP)  {% endcondition %}
            THEN ${marge_brute}
          END ;;
  }

  measure: sum_nb_ticket_select_mois_N3 {
    label: "Nb clts n-3"
    type: sum
    value_format_name: decimal_0
    sql: CASE
            WHEN {% condition date_filter_3 %} CAST(${dte_vte_date} AS TIMESTAMP)  {% endcondition %}
            THEN ${nb_ticket}
          END ;;
  }

  measure: sum_nb_jour_select_mois_N3 {
    hidden: yes
    type: count_distinct
    value_format_name: decimal_0
    sql: CASE
            WHEN {% condition date_filter_3 %} CAST(${dte_vte_date} AS TIMESTAMP)  {% endcondition %}
            THEN ${dte_vte_date}
          END ;;
  }

  measure: sum_val_achat_gbl_select_mois_N3 {
    hidden: yes
    type: sum
    value_format_name: eur
    sql: CASE
            WHEN {% condition date_filter_3 %} CAST(${dte_vte_date} AS TIMESTAMP)  {% endcondition %}
            THEN ${val_achat_gbl}
          END ;;
  }


  ######### calcul des rapports entre les KPIs à la période n sélectionnée au niveau du filtre  ##########


  measure: client_par_jour_select_mois {
    label: "clts / jour"
    value_format_name: decimal_0
    type: number
    sql: ${sum_nb_ticket_select_mois}/NULLIF(${sum_nb_jour_select_mois},0) ;;
  }

  measure: ca_par_jour_select_mois {
    label: "CA / jour"
    value_format_name: eur
    type: number
    sql:  ${sum_CA_select_mois}/NULLIF(${sum_nb_jour_select_mois},0) ;;
  }

  measure: ca_par_m_carre_select_mois {
    label: "CA / m²"
    value_format_name: eur
    type: number
    sql:  ${sum_CA_select_mois}/NULLIF(${sum_surf_select_mois},0) ;;
  }

  measure: taux_de_marge_select_mois {
    label: "% marge"
    value_format_name: percent_2
    type: number
    sql: 1.0 * ${sum_marge_select_mois}/NULLIF(${sum_CA_select_mois},0);;
  }

  measure: panier_moyen_select_mois {
    label: "PM"
    value_format_name: decimal_2
    type: number
    sql:  ${sum_CA_select_mois}/NULLIF(${sum_nb_ticket_select_mois},0) ;;
  }

  measure: panier_moyen_drive_select_mois {
    label: "PM Drive"
    value_format_name: decimal_2
    type: number
    sql:  ${sum_CA_drive_select_mois}/NULLIF(${sum_Nb_cde_drive_select_mois},0) ;;
  }

  measure: marge_par_client_select_mois {
    label: "marge / clts"
    value_format_name: decimal_2
    type: number
    sql: ${sum_marge_select_mois}/NULLIF(${sum_nb_ticket_select_mois},0) ;;
  }


  ######### calcul des rapports entre les KPIs à la période n-1 sélectionnée au niveau du filtre  ##########

  measure: client_par_jour_select_mois_N1 {
    label: "clts/jr n-1"
    value_format_name: decimal_0
    type: number
    sql: ${sum_nb_ticket_select_mois_N1}/NULLIF(${sum_nb_jour_select_mois_N1},0) ;;
  }

  measure: ca_par_jour_select_mois_N1 {
    label: "CA/jr n-1"
    value_format_name: eur
    type: number
    sql:  ${sum_CA_select_mois_N1}/NULLIF(${sum_nb_jour_select_mois_N1},0) ;;
  }

  measure: ca_par_m_carre_select_mois_N1 {
    label: "CA/m² n-1"
    value_format_name: eur
    type: number
    sql:  ${sum_CA_select_mois_N1}/NULLIF(${sum_surf_select_mois},0) ;;
  }

  measure: taux_de_marge_select_mois_N1 {
    label: "% marge n-1"
    value_format_name: percent_2
    type: number
    sql: 1.0 * ${sum_marge_select_mois_N1}/NULLIF(${sum_CA_select_mois_N1},0);;
  }

  measure: panier_moyen_select_mois_N1 {
    label: "PM n-1"
    value_format_name: decimal_2
    type: number
    sql:  ${sum_CA_select_mois_N1}/NULLIF(${sum_nb_ticket_select_mois_N1},0) ;;
  }

  measure: marge_par_client_select_mois_N1 {
    label: "marge/clts n-1"
    value_format_name: decimal_2
    type: number
    sql: ${sum_marge_select_mois_N1}/NULLIF(${sum_nb_ticket_select_mois_N1},0) ;;
  }



  ######### calcul des rapports entre les KPIs à la période n-2 sélectionnée au niveau du filtre  ##########


  measure: client_par_jour_select_mois_N2 {
    label: "clts/jr n-2"
    value_format_name: decimal_0
    type: number
    sql: ${sum_nb_ticket_select_mois_N2}/NULLIF(${sum_nb_jour_select_mois_N2},0) ;;
  }

  measure: ca_par_jour_select_mois_N2 {
    label: "CA/jr n-2"
    value_format_name: eur
    type: number
    sql:  ${sum_CA_select_mois_N2}/NULLIF(${sum_nb_jour_select_mois_N2},0) ;;
  }

  measure: ca_par_m_carre_select_mois_N2 {
    label: "CA/m² n-2"
    value_format_name: eur
    type: number
    sql:  ${sum_CA_select_mois_N2}/NULLIF(${sum_surf_select_mois},0) ;;
  }

  measure: taux_de_marge_select_mois_N2 {
    label: "% marge n-2"
    value_format_name: percent_2
    type: number
    sql: 1.0 * ${sum_marge_select_mois_N2}/NULLIF(${sum_CA_select_mois_N2},0);;
  }

  measure: panier_moyen_select_mois_N2 {
    label: "PM n-2"
    value_format_name: decimal_2
    type: number
    sql:  ${sum_CA_select_mois_N2}/NULLIF(${sum_nb_ticket_select_mois_N2},0) ;;
  }

  measure: marge_par_client_select_mois_N2 {
    label: "marge/clts n-2"
    value_format_name: decimal_2
    type: number
    sql: ${sum_marge_select_mois_N2}/NULLIF(${sum_nb_ticket_select_mois_N2},0) ;;
  }



  ######### calcul des rapports entre les KPIs à la période n-3 sélectionnée au niveau du filtre  ##########


  measure: client_par_jour_select_mois_N3 {
    label: "clts/jr n-3"
    value_format_name: decimal_0
    type: number
    sql: ${sum_nb_ticket_select_mois_N3}/NULLIF(${sum_nb_jour_select_mois_N3},0) ;;
  }

  measure: ca_par_jour_select_mois_N3 {
    label: "CA/jr n-3"
    value_format_name: eur
    type: number
    sql:  ${sum_CA_select_mois_N3}/NULLIF(${sum_nb_jour_select_mois_N3},0) ;;
  }

  measure: ca_par_m_carre_select_mois_N3 {
    label: "CA/m² n-3"
    value_format_name: eur
    type: number
    sql:  ${sum_CA_select_mois_N3}/NULLIF(${sum_surf_select_mois},0) ;;
  }

  measure: taux_de_marge_select_mois_N3 {
    label: "% marge n-3"
    value_format_name: percent_2
    type: number
    sql: 1.0 * ${sum_marge_select_mois_N3}/NULLIF(${sum_CA_select_mois_N3},0);;
  }

  measure: panier_moyen_select_mois_N3 {
    label: "PM n-3"
    value_format_name: decimal_2
    type: number
    sql:  ${sum_CA_select_mois_N3}/NULLIF(${sum_nb_ticket_select_mois_N3},0) ;;
  }

  measure: marge_par_client_select_mois_N3 {
    label: "marge/clts n-3"
    value_format_name: decimal_2
    type: number
    sql: ${sum_marge_select_mois_N3}/NULLIF(${sum_nb_ticket_select_mois_N3},0) ;;
  }


  ########### Calcul des progressions n vs n-1 à la péridode sélectionée au niveau du filtre ###########


  measure: prog_CA_select_mois {
    label: "prog CA"
    value_format_name: percent_2
    type: number
    sql: 1.0 * (${sum_CA_select_mois}-${sum_CA_select_mois_N1})/NULLIF(${sum_CA_select_mois_N1},0);;
  }

  measure: prog_CA_Drive_select_mois {
    label: "prog CA Drive"
    value_format_name: percent_2
    type: number
    sql: 1.0 * (${sum_CA_drive_select_mois}-${sum_CA_drive_select_mois_N1})/NULLIF(${sum_CA_drive_select_mois_N1},0);;
  }

  measure: prog_marge_select_mois {
    label: "prog marge"
    value_format_name: percent_2
    type: number
    sql:  1.0 * (${sum_marge_select_mois}-${sum_marge_select_mois_N1})/NULLIF(${sum_marge_select_mois_N1},0);;
  }

  measure: prog_taux_marge_select_mois {
    label: "prog %marge"
    value_format_name: percent_2
    type: number
    sql:  1.0 * (${taux_de_marge_select_mois}-${taux_de_marge_select_mois_N1})/NULLIF(${taux_de_marge_select_mois_N1},0);;
  }

  measure: prog_ca_par_m_carre_select_mois {
    label: "prog CA/m²"
    value_format_name: percent_2
    type: number
    sql:  1.0 * (${ca_par_m_carre_select_mois}-${ca_par_m_carre_select_mois_N1})/NULLIF(${ca_par_m_carre_select_mois_N1},0);;
  }

  measure: prog_Clients_select_mois {
    label: "prog clts/jr"
    value_format_name: percent_2
    type: number
    sql: 1.0 * (${client_par_jour_select_mois}-${client_par_jour_select_mois_N1})/NULLIF(${client_par_jour_select_mois_N1},0) ;;
  }

  measure: prog_nb_Clients_select_mois {
    label: "prog nb clts"
    value_format_name: percent_2
    type: number
    sql: 1.0 * (${sum_nb_ticket_select_mois}-${sum_nb_ticket_select_mois_N1})/NULLIF(${sum_nb_ticket_select_mois_N1},0) ;;
  }

  measure: prog_ca_jour_select_mois {
    label: "prog CA / jr"
    value_format_name: percent_2
    type: number
    sql: 1.0 * (${ca_par_jour_select_mois}-${ca_par_jour_select_mois_N1})/NULLIF(${ca_par_jour_select_mois_N1},0) ;;
  }

  measure: prog_PM_select_mois {
    label: "prog PM"
    value_format_name: percent_2
    type: number
    sql: 1.0 * (${panier_moyen_select_mois}-${panier_moyen_select_mois_N1})/(NULLIF(${panier_moyen_select_mois_N1},0));;
  }

  measure: prog_marge_client_select_mois {
    label: "prog marge/clt"
    value_format_name: percent_2
    type: number
    sql: 1.0 * (${marge_par_client_select_mois}-${marge_par_client_select_mois_N1})/NULLIF(${marge_par_client_select_mois_N1},0);;
  }



  ######### Calcul des progressions n-1 vs n-2 à la péridode sélectionée au niveau du filtre #########

  measure:prog_ca_select_mois_N1 {
    label: "prog CA n-1"
    value_format_name: percent_2
    type: number
    sql: 1.0 * (${sum_CA_select_mois_N1}-${sum_CA_select_mois_N2})/NULLIF(${sum_CA_select_mois_N2},0);;
  }

  measure: prog_marge_select_mois_N1 {
    label: "prog marge n-1"
    value_format_name: percent_2
    type: number
    sql:  1.0 * (${sum_marge_select_mois_N1}-${sum_marge_select_mois_N2})/NULLIF(${sum_marge_select_mois_N2},0);;
  }

  measure: prog_ca_par_m_carre_select_mois_N1 {
    label: "prog CA/m² n-1"
    value_format_name: percent_2
    type: number
    sql:  1.0 * (${ca_par_m_carre_select_mois_N1}-${ca_par_m_carre_select_mois_N2})/NULLIF(${ca_par_m_carre_select_mois_N2},0);;
  }

  measure: prog_nb_Clients_select_mois_N1 {
    label: "prog nb clts n-1"
    value_format_name: percent_2
    type: number
    sql: 1.0 * (${sum_nb_ticket_select_mois_N1}-${sum_nb_ticket_select_mois_N2})/NULLIF(${sum_nb_ticket_select_mois_N2},0) ;;
  }

  measure: prog_taux_marge_select_mois_N1 {
    label: "prog %marge n-1"
    value_format_name: percent_2
    type: number
    sql:  1.0 * (${taux_de_marge_select_mois_N1}-${taux_de_marge_select_mois_N2})/NULLIF(${taux_de_marge_select_mois_N2},0);;
  }

  measure: prog_Clients_select_mois_N1 {
    label: "prog clts/jr n-1"
    value_format_name: percent_2
    type: number
    sql: 1.0 * (${client_par_jour_select_mois_N1}-${client_par_jour_select_mois_N2})/NULLIF(${client_par_jour_select_mois_N2},0) ;;
  }

  measure: prog_ca_jour_select_mois_N1 {
    label: "prog CA/jr n-1"
    value_format_name: percent_2
    type: number
    sql: 1.0 * (${ca_par_jour_select_mois_N1}-${ca_par_jour_select_mois_N2})/NULLIF(${ca_par_jour_select_mois_N2},0) ;;
  }

  measure: prog_PM_select_mois_N1 {
    label: "prog PM n-1"
    value_format_name: percent_2
    type: number
    sql: 1.0 * (${panier_moyen_select_mois_N1}-${panier_moyen_select_mois_N2})/(NULLIF(${panier_moyen_select_mois_N2},0));;
  }

  measure: prog_marge_client_select_mois_N1 {
    label: "prog marge/clt n-1"
    value_format_name: percent_2
    type: number
    sql: 1.0 * (${marge_par_client_select_mois_N1}-${marge_par_client_select_mois_N2})/NULLIF(${marge_par_client_select_mois_N2},0);;
  }


  ######### Calcul des progressions n-2 vs n-3 à la péridode sélectionée au niveau du filtre #########

  measure:prog_ca_select_mois_N2 {
    label: "prog CA n-2"
    value_format_name: percent_2
    type: number
    sql: 1.0 * (${sum_CA_select_mois_N2}-${sum_CA_select_mois_N3})/NULLIF(${sum_CA_select_mois_N3},0);;
  }

  measure: prog_marge_select_mois_N2 {
    label: "prog marge n-2"
    value_format_name: percent_2
    type: number
    sql:  1.0 * (${sum_marge_select_mois_N2}-${sum_marge_select_mois_N3})/NULLIF(${sum_marge_select_mois_N3},0);;
  }

  measure: prog_ca_par_m_carre_select_mois_N2 {
    label: "prog CA/m² n-2"
    value_format_name: percent_2
    type: number
    sql:  1.0 * (${ca_par_m_carre_select_mois_N2}-${ca_par_m_carre_select_mois_N3})/NULLIF(${ca_par_m_carre_select_mois_N3},0);;
  }

  measure: prog_taux_marge_select_mois_N2 {
    label: "prog %marge n-2"
    value_format_name: percent_2
    type: number
    sql:  1.0 * (${taux_de_marge_select_mois_N2}-${taux_de_marge_select_mois_N3})/NULLIF(${taux_de_marge_select_mois_N3},0);;
  }

  measure: prog_Clients_select_mois_N2 {
    label: "prog clts/jr n-2"
    value_format_name: percent_2
    type: number
    sql: 1.0 * (${client_par_jour_select_mois_N2}-${client_par_jour_select_mois_N3})/NULLIF(${client_par_jour_select_mois_N3},0) ;;
  }

  measure: prog_nb_Clients_select_mois_N3 {
    label: "prog nb clts n-2"
    value_format_name: percent_2
    type: number
    sql: 1.0 * (${sum_nb_ticket_select_mois_N2}-${sum_nb_ticket_select_mois_N3})/NULLIF(${sum_nb_ticket_select_mois_N3},0) ;;
  }

  measure: prog_ca_jour_select_mois_N2 {
    label: "prog CA/jr n-2"
    value_format_name: percent_2
    type: number
    sql: 1.0 * (${ca_par_jour_select_mois_N2}-${ca_par_jour_select_mois_N3})/NULLIF(${ca_par_jour_select_mois_N3},0) ;;
  }

  measure: prog_PM_select_mois_N2 {
    label: "prog PM n-2"
    value_format_name: percent_2
    type: number
    sql: 1.0 * (${panier_moyen_select_mois_N2}-${panier_moyen_select_mois_N3})/(NULLIF(${panier_moyen_select_mois_N3},0));;
  }

  measure: prog_marge_client_select_mois_N2 {
    label: "prog marge/clt n-2"
    value_format_name: percent_2
    type: number
    sql: 1.0 * (${marge_par_client_select_mois_N2}-${marge_par_client_select_mois_N3})/NULLIF(${marge_par_client_select_mois_N3},0);;
  }

}
