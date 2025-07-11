-- *********************************************
-- * Standard SQL generation corrigée
-- *--------------------------------------------
-- * DB-MAIN version: 11.0.2
-- * Generator date: Juin 2025
-- * Modifié par Esteban BARRACHO
-- *********************************************


-- Tables Section
-- _______________

-- TABLE DES RESPONSABLES DE PROJET
create table ResponsableProjet (
                                   id_personnel varchar(10) not null,
                                   niveau_hierarchique varchar(50) not null,
                                   constraint FKPer_Res_ID primary key (id_personnel)
);

-- TABLE DES CLIENTS
create table Client (
                        id_client varchar(10) not null,
                        nom_client varchar(100) not null,
                        adresse TEXT not null,
                        secteur_activite varchar(100) not null,
                        constraint ID_Client_ID primary key (id_client)
);

-- TABLE DU PERSONNEL
create table Personnel (
                           id_personnel varchar(10) not null,
                           type_personnel ENUM('interne', 'externe') not null,
                           nom varchar(100) not null,
                           prenom varchar(100) not null,
                           email varchar(100) not null,
                           fonction varchar(100) not null,
                           taux_honoraire_standard decimal(8,2) not null,
                           constraint ID_Personnel_ID primary key (id_personnel)
);

-- TABLE DES COLLABORATEURS (SPÉCIALISATION DU PERSONNEL)
create table Collaborateur (
                               id_personnel varchar(10) not null,
                               constraint PK_Collaborateur primary key (id_personnel),
                               constraint FKPer_Col_FK foreign key (id_personnel) references Personnel(id_personnel)
);

-- TABLE DES FACTURES (créée avant Phase pour éviter erreur de FK)
create table Facture (
                         id_facture varchar(10) not null,
                         date_emission date not null,
                         montant_facture decimal(10,2) not null,
                         transmission_electronique boolean not null,
                         annexe TEXT not null,
                         statut ENUM('émise', 'payée', 'en attente') not null,
                         reference_banque varchar(100) not null,
                         fichier_facture TEXT not null,
                         constraint ID_Facture_ID primary key (id_facture)
);

-- TABLE DES PHASES DE PROJET
create table Phase (
                       id_phase varchar(10) not null,
                       nom_phase varchar(100) not null,
                       ordre_phase INT not null,
                       montant_phase decimal(10,2) not null,
                       id_facture varchar(10),
                       constraint ID_Phase_ID primary key (id_phase),
                       foreign key (id_facture) references Facture(id_facture)
);

-- TABLE DES PROJETS
create table Projet (
                        id_projet varchar(10) not null,
                        nom_projet varchar(100) not null,
                        statut varchar(50) not null,
                        date_debut date not null,
                        date_fin date not null,
                        montant_total_estime decimal(12,2) not null,
                        type_marche varchar(50) not null,
                        id_client varchar(10) not null,
                        constraint ID_Projet_ID primary key (id_projet),
                        foreign key (id_client) references Client(id_client)
);

-- TABLE ASSOCIATIVE GERER (ResponsableProjet ↔ Projet)
create table Gerer (
                       id_projet varchar(10) not null,
                       id_personnel varchar(10) not null,
                       constraint ID_Gerer_ID primary key (id_personnel, id_projet),
                       foreign key (id_personnel) references ResponsableProjet(id_personnel),
                       foreign key (id_projet) references Projet(id_projet)
);

-- TABLE DES TÂCHES
create table Tache (
                       id_tache varchar(10) not null,
                       id_phase varchar(10) not null,
                       nom_tache varchar(100) not null,
                       description TEXT not null,
                       alerte_retard boolean not null,
                       conges_integres boolean not null,
                       statut ENUM('à faire', 'en cours', 'terminé') not null,
                       est_realisable boolean not null,
                       date_debut date not null,
                       date_fin date not null,
                       constraint ID_Tache_ID primary key (id_tache),
                       foreign key (id_phase) references Phase(id_phase)
);

-- TABLE DE PLANIFICATION DES COLLABORATEURS
create table PlanificationCollaborateur (
                                            id_planification varchar(10) not null,
                                            id_tache varchar(10) not null,
                                            id_collaborateur varchar(10) not null,
                                            heures_disponibles decimal(5,2) not null,
                                            alerte_depassement boolean not null,
                                            semaine varchar(10) not null,
                                            heures_prevues decimal(5,2) not null,
                                            constraint ID_PlanificationCollaborateur_ID primary key (id_planification),
                                            foreign key (id_tache) references Tache(id_tache),
                                            foreign key (id_collaborateur) references Collaborateur(id_personnel)
);

-- TABLE DES PRESTATIONS DES COLLABORATEURS
create table PrestationCollaborateur (
                                         id_prestation varchar(10) not null,
                                         date date not null,
                                         id_tache varchar(10) not null,
                                         id_collaborateur varchar(10) not null,
                                         heures_effectuees decimal(5,2) not null,
                                         mode_facturation ENUM('horaire', 'forfaitaire') not null,
                                         facture_associee varchar(10),
                                         taux_horaire decimal(8,2) not null,
                                         commentaire TEXT not null,
                                         constraint ID_PrestationCollaborateur_ID primary key (id_prestation),
                                         foreign key (id_tache) references Tache(id_tache),
                                         foreign key (id_collaborateur) references Collaborateur(id_personnel),
                                         foreign key (facture_associee) references Facture(id_facture)
);

-- TABLE DES COÛTS
create table Cout (
                      id_cout varchar(10) not null,
                      type_cout varchar(50) not null,
                      montant decimal(10,2) not null,
                      nature_cout ENUM('interne', 'externe', 'logiciel', 'matériel', 'sous-traitant') not null,
                      date date not null,
                      source varchar(50) not null,
                      constraint ID_Cout_ID primary key (id_cout)
);

-- TABLE DES PROJECTIONS DE FACTURATION
create table ProjectionFacturation (
                                       id_projection varchar(10) not null,
                                       mois varchar(7) not null,
                                       montant_projete decimal(10,2) not null,
                                       montant_facturable_actuel decimal(10,2) not null,
                                       seuil_minimal decimal(10,2) not null,
                                       alerte_facturation boolean not null,
                                       id_projet varchar(10) not null,
                                       constraint ID_ProjectionFacturation_ID primary key (id_projection),
                                       foreign key (id_projet) references Projet(id_projet)
);

-- TABLE DES LOGS D'IMPORT
create table ImportLog (
                           id_import varchar(10) not null,
                           source varchar(100) not null,
                           type_donnee varchar(50) not null,
                           date_import date not null,
                           statut varchar(20) not null,
                           message_log TEXT not null,
                           constraint ID_ImportLog_ID primary key (id_import)
);

