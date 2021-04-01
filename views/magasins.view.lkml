view: magasins {
  sql_table_name: `bv-prod.Matillion_Perm_Table.Magasins`
    ;;

  dimension: adresse {
    type: string
    sql: ${TABLE}.Adresse ;;
  }

  dimension: adresse_url {
    type: string
    sql: ${TABLE}.adresse_url ;;
  }

  dimension: animateur {
    type: string
    sql: ${TABLE}.Animateur ;;
  }

  dimension: assistance_informatiq {
    type: string
    sql: ${TABLE}.assistance_informatiq ;;
  }

  dimension: capital_social {
    type: string
    sql: ${TABLE}.Capital_social ;;
  }

  dimension: carte_american_express {
    type: string
    sql: ${TABLE}.carte_american_express ;;
  }

  dimension: carte_kdeos {
    type: string
    sql: ${TABLE}.carte_kdeos ;;
  }

  dimension: cd_comptable {
    type: string
    sql: ${TABLE}.CD_Comptable ;;
  }

  dimension: cd_logiciel {
    type: string
    sql: ${TABLE}.CD_Logiciel ;;
  }

  dimension: cd_magasin {
    type: string
    primary_key: yes
    sql: ${TABLE}.CD_Magasin ;;
  }

  dimension: click_collect {
    type: string
    sql: ${TABLE}.click_collect ;;
  }

  dimension: code_postal {
    type: string
    sql: ${TABLE}.Code_postal ;;
  }

  dimension: complement_adr {
    type: string
    sql: ${TABLE}.Complement_Adr ;;
  }

  dimension: couverture_livre {
    type: string
    sql: ${TABLE}.couverture_livre ;;
  }

  dimension_group: date_ouv {
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
    sql: ${TABLE}.DATE_OUV ;;
  }

  dimension: delai_min_prep_cde {
    type: string
    sql: ${TABLE}.delai_min_prep_cde ;;
  }

  dimension: delais_livraison_jr_ouvr {
    type: string
    sql: ${TABLE}.delais_livraison_jr_ouvr ;;
  }

  dimension: directeur {
    type: string
    sql: ${TABLE}.Directeur ;;
  }

  dimension: email_clients {
    type: string
    sql: ${TABLE}.Email_clients ;;
  }

  dimension: email_confirm_engag {
    type: string
    sql: ${TABLE}.Email_confirm_engag ;;
  }

  dimension: email_franchise {
    type: string
    sql: ${TABLE}.Email_franchise ;;
  }

  dimension: email_recep_com {
    type: string
    sql: ${TABLE}.Email_recep_com ;;
  }

  dimension: email_reservation {
    type: string
    sql: ${TABLE}.Email_reservation ;;
  }

  dimension: fax {
    type: string
    sql: ${TABLE}.Fax ;;
  }

  dimension: ferme {
    label: "Type"
    type: string
    sql: ${TABLE}.Ferme ;;
  }

  dimension: format {
    type: string
    sql: ${TABLE}.Format ;;
  }

  dimension: franchise {
    type: string
    sql: ${TABLE}.Franchise ;;
  }

  dimension: horaires_dimanche {
    type: string
    sql: ${TABLE}.Horaires_dimanche ;;
  }

  dimension: horaires_jeudi {
    type: string
    sql: ${TABLE}.Horaires_jeudi ;;
  }

  dimension: horaires_lundi {
    type: string
    sql: ${TABLE}.Horaires_lundi ;;
  }

  dimension: horaires_mardi {
    type: string
    sql: ${TABLE}.Horaires_mardi ;;
  }

  dimension: horaires_mercredi {
    type: string
    sql: ${TABLE}.Horaires_mercredi ;;
  }

  dimension: horaires_samedi {
    type: string
    sql: ${TABLE}.Horaires_samedi ;;
  }

  dimension: horaires_vendredi {
    type: string
    sql: ${TABLE}.Horaires_vendredi ;;
  }

  dimension: impression_copieur {
    type: string
    sql: ${TABLE}.impression_copieur ;;
  }

  dimension: impression_grd_format {
    type: string
    sql: ${TABLE}.impression_grd_format ;;
  }

  dimension: latitude {
    type: string
    sql: ${TABLE}.Latitude ;;
  }

  dimension: lien_visite_virtuelle {
    type: string
    sql: ${TABLE}.lien_visite_virtuelle ;;
  }

  dimension: livraison_depart_mag {
    type: string
    sql: ${TABLE}.livraison_depart_mag ;;
  }

  dimension: location_materiel {
    type: string
    sql: ${TABLE}.location_materiel ;;
  }

  dimension: longitude {
    type: string
    sql: ${TABLE}.Longitude ;;
  }

  dimension: montage_meuble {
    type: string
    sql: ${TABLE}.montage_meuble ;;
  }

  dimension: mtant_min_cde_ttc {
    type: string
    sql: ${TABLE}.Mtant_min_cde_TTC ;;
  }

  dimension: nom {
    type: string
    sql: ${TABLE}.NOM ;;
  }

  dimension: nom_tbe {
    type: string
    sql: ${TABLE}.Nom_TBE ;;
  }

  dimension: num_cpte_ingenico {
    type: string
    sql: ${TABLE}.Num_cpte_ingenico ;;
  }

  dimension: num_rcs {
    type: string
    sql: ${TABLE}.Num_RCS ;;
  }

  dimension: num_tva {
    type: string
    sql: ${TABLE}.Num_TVA ;;
  }

  dimension: objets_perso {
    type: string
    sql: ${TABLE}.objets_perso ;;
  }

  dimension: paiement_plusieurs_fois {
    type: string
    sql: ${TABLE}.paiement_plusieurs_fois ;;
  }

  dimension: pays {
    type: string
    sql: ${TABLE}.Pays ;;
  }

  dimension: pays_tbe {
    type: string
    sql: ${TABLE}.Pays_TBE ;;
  }

  dimension: phone_magasin {
    type: string
    sql: ${TABLE}.Phone_Magasin ;;
  }

  dimension: photocopie_noir_blanc {
    type: string
    sql: ${TABLE}.photocopie_noir_blanc ;;
  }

  dimension: portable {
    type: string
    sql: ${TABLE}.Portable ;;
  }

  dimension: portable_2 {
    type: string
    sql: ${TABLE}.Portable_2 ;;
  }

  dimension: portable_3 {
    type: string
    sql: ${TABLE}.Portable_3 ;;
  }

  dimension: rachat_calculatrice {
    type: string
    sql: ${TABLE}.rachat_calculatrice ;;
  }

  dimension: rachat_cartouche {
    type: string
    sql: ${TABLE}.rachat_cartouche ;;
  }

  dimension: raison_sociale {
    type: string
    sql: ${TABLE}.Raison_sociale ;;
  }

  dimension: region {
    type: string
    sql: ${TABLE}.Region ;;
  }

  dimension: reliure_doc_plastification {
    type: string
    sql: ${TABLE}.reliure_doc_plastification ;;
  }

  dimension: reproduction_cles {
    type: string
    sql: ${TABLE}.reproduction_cles ;;
  }

  dimension: siret {
    type: string
    sql: ${TABLE}.Siret ;;
  }

  dimension: support_com_event {
    type: string
    sql: ${TABLE}.support_com_event ;;
  }

  dimension: supports_com_insti {
    type: string
    sql: ${TABLE}.supports_com_insti ;;
  }

  dimension: supports_plv {
    type: string
    sql: ${TABLE}.supports_PLV ;;
  }

  dimension: surf_vte {
    type: number
    sql: ${TABLE}.SURF_VTE ;;
  }

  dimension: tampons_plaques {
    type: string
    sql: ${TABLE}.tampons_plaques ;;
  }

  dimension: tarif_livraison_ttc {
    type: string
    sql: ${TABLE}.tarif_livraison_TTC ;;
  }

  dimension: tranche_age {
    type: string
    sql: ${TABLE}.Tranche_age ;;
  }

  dimension: typ_mag {
    type: string
    sql: ${TABLE}.TYP_MAG ;;
  }

  dimension: type_tbe {
    type: string
    sql: ${TABLE}.Type_TBE ;;
  }

  dimension: ville {
    type: string
    sql: ${TABLE}.Ville ;;
  }

  dimension: groupe_region {
    sql: CASE
            WHEN ${region} IN ('BE' , 'CAM' , 'ESP' , 'TUN' , 'MAU' , 'MAL' , 'IT' , 'TOM') THEN "International"
            WHEN ${region} IN ('RNW' , 'RSW' , 'RN' , 'RRA' , 'RSE' , 'RNE') THEN "France Metro"
         END
        ;;
  }

  measure: count {
    type: count
    drill_fields: []
  }
}
