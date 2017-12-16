/**
* Name: modele3SansPropagationFeuAvecTousProfils
* Author: DIALLO Azise Oumar
* Description: 3e modele avec les foyers de feu sans propagation et tous les profils d'agents
* Tags: Tag1, Tag2, TagN
*/

model modele3SansPropagationFeuAvecTousProfils

/* Insert your model definition here */


global {

	int width_and_height_of_environment const: true <- 1000; 	// lageur de la de l'environnement
	geometry shape <- rectangle(width_and_height_of_environment # m, width_and_height_of_environment # m);
	int nbreArbre;												// nombre d'arbre
	int nbreBatiment;											// nombre de batiment
	int nbreFeu;												// nombre de feu au debut
	int intervalPropagation;									// intervalle de propagation du feu
	int dureeCremationArbre const: true <- 1800; 				// temps nécessaire pourqu'un arbre se consomme totalement
 	int dureeCremationBatiment const: true <- 1500; 			// temps nécessaire pourqu'un batiment se consomme totalement
 	int tailleFeu <- 0;
 	int tailleBatiment <-0;
 	int tempsPropagationArbre <-10;
 	int tempsPropagationBatiment <-20;
 	float probaBrule;											// Probabilite qu'un arbre ou un batiment soit brule
 	list<arbre> listArbreEnFeu;
 	
 	int nbreAgentProfil;

 	
 	 int nb_feu <-0;	
 	 
 	float percepSubjectivityPeur;		// peureux
	float dangerFamNonFami;				// non familier
	float dangerFamExp;					// familier
	float percepSubjectivityOpti;		// optimiste
	float percepSubjectivityObjectif; 	// objectif
	int PerceptionRange;				// rayon de perception d'un habiatant  a 360 degre
	
	
	float dangerEnvCraintifNonExperimente update: mean(habitantProfil1 collect(each.dangerEnvSurjectif));			// moyenne de la dangeriosite du milieu percu par des agents craintifs et non experimentes
	float dangerEnvCraintifExperimente <-0.0;				// moyenne de la dangeriosite du milieu percu par des agents craintifs et experimentes
	float dangerEnvOptimisteNonExperimente <-0.0;			// moyenne de la dangeriosite du milieu percu par des agents optimistes et non experimentes
	float dangerEnvOptimisteExperimente <-0.0;				// moyenne de la dangeriosite du milieu percu par des agents optimistes et experimentes
	float dangerEnvObjectifNonExperimente <-0.0;			// moyenne de la dangeriosite du milieu percu par des agents objectifs et non experimentes
	float dangerEnvObjectifExperimente <-0.0;				// moyenne de la dangeriosite du milieu percu par des agents objectifs et experimentes
	
 	
	init{
		// Creation de nbreArbre arbres sains au départ
	 	create arbre number: nbreArbre
		{
			set listArbreEnFeu value: ((self neighbors_at intervalPropagation) of_species arbre) where (each.state = 'burning');
		} 
		
		// Creation de nbreBatiment batiment  au départ
		create batiment number: nbreBatiment
		{
		}
		
		// start fires
		ask target: nbreFeu among (arbre as list)
		{
			set state value: 'burning';
		}
		
		set nb_feu value:length (listArbreEnFeu);
		
		create habitantProfil1 number: nbreAgentProfil
		{
			//location <-point(width_and_height_of_environment/2, width_and_height_of_environment/2);
			
		}
		
		create habitantProfil2 number: nbreAgentProfil
		{
			//location <-point(width_and_height_of_environment/2, width_and_height_of_environment/2);
		}
		
		create habitantProfil3 number: nbreAgentProfil
		{
			//location <-point(width_and_height_of_environment/2, width_and_height_of_environment/2);
		}
		
		create habitantProfil4 number: nbreAgentProfil
		{
			//location <-point(width_and_height_of_environment/2, width_and_height_of_environment/2);
		}
		
		create habitantProfil5 number: nbreAgentProfil
		{
			//location <-point(width_and_height_of_environment/2, width_and_height_of_environment/2);
		}
		
		create habitantProfil6 number: nbreAgentProfil
		{
			//location <-point(width_and_height_of_environment/2, width_and_height_of_environment/2);
		}

	}
	
	float fearEnvCraintifNonExperimente update: mean(habitantProfil1 collect(each.fearEnv));				// moyenne du nviveau d'intensite de la peur des agents craintifs et non experimentes
	float fearEnvCraintifExperimente update: mean(habitantProfil2 collect(each.fearEnv));					// moyenne du nviveau d'intensite de la peur des agents craintifs et experimentes
	float fearEnvOptimisteNonExperimente update: mean(habitantProfil3 collect(each.fearEnv));				// moyenne du nviveau d'intensite de la peur des agents optimistes et non experimentes
	float fearEnvOptimisteExperimente update: mean(habitantProfil4 collect(each.fearEnv));				// moyenne du nviveau d'intensite de la peur des agents optimistes et experimentes
	float fearEnvObjectifNonExperimente update: mean(habitantProfil5 collect(each.fearEnv));				// moyenne du nviveau d'intensite de la peur des agents objectifs et non experimentes
	float fearEnvObjectifExperimente update: mean(habitantProfil6 collect(each.fearEnv));					// moyenne du nviveau d'intensite de la peur des agents objectifs et experimentes	
	
}	


// ceci est agent inflammable
species inflammable control: fsm{
		int size; 									// taille de chaque element correspondant a son diametre. Diametre dependant du type d'agent
		int temp <- 0;								// temps necessaire pour bruler une surface donnee
		rgb color;
		int dureeCremation;
		int tempsPropagation;
		int duration <- 0;
			
		
		state intact initial: true
		{
			
			color<- color;

		}

		state burning
		{

			duration <- duration + 1;
			color <- rgb(255, rnd(255), 0);

			transition to: destroyed when: duration >= dureeCremation;
		}

		state destroyed
		{
			create species: detruit number: 1 with: [location::my location]
			{
				
			}	
			do action: die;
		}

		
	}

	


// ceci est un arbre sain qui est vert et sa taille varie entre 1 et 2 cases
 species arbre parent: inflammable
{
	
	init
	{
		color <-#forestgreen;
		tempsPropagation <- tempsPropagationArbre;
		dureeCremation <- dureeCremationArbre;
		size <- 1 + rnd(1);
		location <- point(rnd(width_and_height_of_environment - 2 * size) + size, rnd(width_and_height_of_environment - 2 * size) + size);
	}


	aspect base
	{
		draw circle(size) color:color;
	}

} 

// ceci est un batiment 
species batiment parent: inflammable
{
	
	init
	{
		color <-#grey;
		tempsPropagation <- tempsPropagationBatiment;
		dureeCremation <- dureeCremationBatiment;
		size <- 10 + rnd(5);
		location <- point(rnd(width_and_height_of_environment - 2 * size) + size, rnd(width_and_height_of_environment - 2 * size) + size);
	}

	aspect base
	{
		draw square(size) color:color;
	}

} 


 species detruit
{
	int size <- 1;
	aspect base
	{
		draw circle(size) color:#gainsboro;
	}

}



	//Habitant fictif
 species habitantGenerique
	{
		int size const:true <- 2; 										// taille d'un habitant
		int rayonPerception <- 0;										// rayon de perception d'un habiatant  a 360 degre
		float fearEnv <- 0.0;											// le niveau d'intensite de la peur chez un individu
		float dangerFam;												// la familiarite de l'individu avec le danger (plus ce cof est proche de 1, plus l'individu est familier. Dans le cas contraire cad proche 0 il est peu familier)
		float percepSubjectivity;										// la perception surjective d'un individu face a la dangeriosite de l'enviroennement (si ce cof est inferieur a 1, alors l'agent est optimiste et prend moins consceince du danger. Sinon il est pessimiste et peureux)
		bool effetBascule <- false;										// permet de savoir si l'individu a pris conscience du danger
		float dangerEnvObjectif <- 0.0;									// niveau de dangeriosite objective de l'environnment vu par un individu
		float dangerEnvSurjectif <- 0.0;								// niveau de dangeriosite sujective de l'environnment vu par un individu
		
		
		list listFeuArbre update: (arbre at_distance rayonPerception) where (each.state = 'burning');
		
		list listFeuBatiement update: (batiment at_distance rayonPerception) where (each.state = 'burning');
		
		//list listFeu <- listFeuArbre union listFeuBatiement;
				
		init
		{
			rayonPerception <- PerceptionRange;
			location <-point((width_and_height_of_environment/2 - 2 * size) + size,(width_and_height_of_environment/2 - 2 * size) + size);
		}
		
		
		reflex MiseAJourNiveauPeur{
			
			float distance <-0.0;    			// declaration d'une variable temporaire pour le calcul de la distance de l'individu avec un foyer de feu
			list<arbre> listFeuPriorise <-[];	// priorisation des foyers de feu
			
			if (listFeuArbre!=nil){
				float dangerouness <-0.0;
				loop f over: listFeuArbre{
				
					// Pemier test en considerant le numero d'apparition du feu
					distance <- distance_to(self,f);// sqrt((self.location.x - f.location.x) * (self.location.x - f.location.x) + (self.location.y - f.location.y) * (self.location.y - f.location.y));
					
					dangerouness <-f.size / (((listFeuArbre index_of f) +1) * distance); // calcul de la dangeriosite objective d'un element feu
					
					dangerEnvObjectif <- dangerEnvObjectif + dangerouness; 			// calcul de la dangeriosite objective de l'environnement
			
				}
			}
			
			//write("Apres la boucle");
			//write(dangerEnvObjectif);
			
			dangerEnvSurjectif <- percepSubjectivity * dangerEnvObjectif;       // calcul de la dangeriosite sujective de l'environnement vu par un individu
			write("Dangeriosite surjective est : ");
			write(dangerEnvSurjectif);
			
			fearEnv <- 1 / (1+ exp(6-(1-dangerFam) * dangerEnvSurjectif));		// calcul de l'intensite de la peur d'un individu
			
		}

		aspect base
		{
			draw circle(size) color:color;
		}
	}

	//Habitant profil1 : individu craintif et non familier avec le danger
 species habitantProfil1 parent:habitantGenerique
	{
		init
		{
			dangerFam <- dangerFamNonFami;
			percepSubjectivity <- percepSubjectivityPeur;
			color <-#orange;
		}
	}
	
	//Habitant profil2 : individu craintif et familier avec le danger (experimente)
 species habitantProfil2 parent:habitantGenerique
	{
		init
		{
			dangerFam <- dangerFamExp;
			percepSubjectivity <- percepSubjectivityPeur;
			color <-#moccasin;
		}
		
	}

	//Habitant profil3 : individu optimiste et non familier avec le danger
 species habitantProfil3 parent:habitantGenerique
	{
		init
		{
			dangerFam <- dangerFamNonFami;
			percepSubjectivity <- percepSubjectivityOpti;
			color <-#yellow;
		}
	}


	//Habitant profil1 : individu optimiste et familier avec le danger
 species habitantProfil4 parent:habitantGenerique
	{
		init
		{
			dangerFam <- dangerFamExp;
			percepSubjectivity <- percepSubjectivityOpti;
			color <-#brown;
		}
		
	}
	
	//Habitant profil5 : individu objectif et non familier avec le danger
 species habitantProfil5 parent:habitantGenerique
	{
		init
		{
			dangerFam <- dangerFamNonFami;
			percepSubjectivity <- percepSubjectivityObjectif;
			color <-#violet;
		}
		
	}

	//Habitant profil6 : individu objectif et familier avec le danger
 species habitantProfil6 parent:habitantGenerique
	{
		init
		{
			dangerFam <- dangerFamExp;
			percepSubjectivity <- percepSubjectivityObjectif;
			color <-#indigo;
		}
		
	}
	
	
		
	
experiment modele3 type: gui {
	
	parameter "nombre d'arbres" var: nbreArbre <- 200 min: 50 max: 500 category: "Environment"; 				// parametre d'entree pour definir le nombre d'arbre a creer au debut de la simulation. Par defaut c'est 100
	parameter "nombre de feux" var: nbreFeu <- 50 min: 50 max: 500 category: "Environment";						// parametre d'entree pour definir le nombre de feu au debut de la simulation. par defaut 10 foyers sont crees
	parameter "nombre de batiments" var: nbreBatiment <- 10 min: 5 max: 100 category: "Environment";				// parametre d'entree pour definir le nombre de batiment  a creer au debut de la simulation. Par defaut c'est 25
	
	parameter "perception d'un individu peureux" var:percepSubjectivityPeur <- 3.0 		category: "Habitant";	// parametre d'entree pour definir la perception sujective de la dangeriosite du milieu par un agent pareux 
	parameter "familiarite d'un individu non familier" var:dangerFamNonFami <- 0.1 		category: "Habitant";	// parametre d'entree pour definir le coefficient de familiarite au danger  par un agent non familier 
	parameter "familiarite d'un individu experimente" var:dangerFamExp <- 0.8 			category: "Habitant";	// parametre d'entree pour definir lle coefficient de familiarite au danger  par un agent familier 
	parameter "perception d'un individu optimiste" var:percepSubjectivityOpti <- 0.5 	category: "Habitant";	// parametre d'entree pour definir la perception sujective de la dangeriosite du milieu par un agent optimiste 
	parameter "perception d'un individu objectif" var:percepSubjectivityObjectif <- 1.0 category: "Habitant";	// parametre d'entree pour definir la perception sujective de la dangeriosite du milieu par un agent objectif 
	parameter "champ de vision d'un individu" var:PerceptionRange <- 50					category: "Habitant";	// parametre d'entree pour definir le champ de vison d'un habitant
	
	parameter "nombre d'agents pour chaque profil" var:nbreAgentProfil <- 1					category: "Habitant";	//nombre d'agents pour chaque profil d'individus

	
	output {		
		
		display main_display
		{
			
			species arbre aspect: base;
			species batiment aspect: base;
			species detruit aspect: base;
			species habitantProfil1 aspect: base;
			species habitantProfil2 aspect: base;
			species habitantProfil3 aspect: base;
			species habitantProfil4 aspect: base;
			species habitantProfil5 aspect: base;
			species habitantProfil6 aspect: base;
		}
		
		display ChartIntensitePeurTtProfil
		{
			chart " Intensite de la peur de tous les profils" type: xy{
				data "fearEnvCraintifNonExperimente" value: fearEnvCraintifNonExperimente color: #orange ;
				data "fearEnvCraintifExperimente" value: fearEnvCraintifExperimente color: #moccasin ;
				data "fearEnvOptimisteNonExperimente" value: fearEnvOptimisteNonExperimente color: #yellow;
				data "fearEnvOptimisteExperimente" value: fearEnvOptimisteExperimente color: #brown ;
				data "fearEnvObjectifNonExperimente" value: fearEnvObjectifNonExperimente color: #violet ;
				data "fearEnvObjectifExperimente" value: fearEnvObjectifExperimente color: #indigo ;
				
			}
		}
		
	}
}
