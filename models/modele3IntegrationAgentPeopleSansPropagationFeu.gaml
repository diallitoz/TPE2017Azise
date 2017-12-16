/**
* Name: modele3IntegrationAgentPeopleSansPropagationFeu
* Author: DIALLO Azise Oumar
* Description: 3e modele en integrant les agents people dans le 1er modele cad sans la propagation du feu.
* Tags: Tag1, Tag2, TagN
*/

model modele3IntegrationAgentPeopleSansPropagationFeu

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
 	
 	int nb_feu -> {length (feu)};								// nombre de feu crees au cours de la simulation


	
	float percepSubjectivityPeur;		// peureux
	float dangerFamNonFami;				// non familier
	float dangerFamExp;					// familier
	float percepSubjectivityOpti;		// optimiste
	float percepSubjectivityObjectif; 	// objectif
	int PerceptionRange;				// rayon de perception d'un habiatant  a 360 degre
	
	
	float dangerEnvCraintifNonExperimente <-0.0;			// moyenne de la dangeriosite du milieu percu par des agents craintifs et non experimentes
	float dangerEnvCraintifExperimente <-0.0;				// moyenne de la dangeriosite du milieu percu par des agents craintifs et experimentes
	float dangerEnvOptimisteNonExperimente <-0.0;			// moyenne de la dangeriosite du milieu percu par des agents optimistes et non experimentes
	float dangerEnvOptimisteExperimente <-0.0;				// moyenne de la dangeriosite du milieu percu par des agents optimistes et experimentes
	float dangerEnvObjectifNonExperimente <-0.0;			// moyenne de la dangeriosite du milieu percu par des agents objectifs et non experimentes
	float dangerEnvObjectifExperimente <-0.0;				// moyenne de la dangeriosite du milieu percu par des agents objectifs et experimentes
	
	float fearEnvCraintifNonExperimente <-0.0;				// moyenne du nviveau d'intensite de la peur des agents craintifs et non experimentes
	float fearEnvCraintifExperimente <-0.0;					// moyenne du nviveau d'intensite de la peur des agents craintifs et experimentes
	float fearEnvOptimisteNonExperimente <-0.0;				// moyenne du nviveau d'intensite de la peur des agents optimistes et non experimentes
	float fearEnvOptimisteExperimente <-0.0;				// moyenne du nviveau d'intensite de la peur des agents optimistes et experimentes
	float fearEnvObjectifNonExperimente <-0.0;				// moyenne du nviveau d'intensite de la peur des agents objectifs et non experimentes
	float fearEnvObjectifExperimente <-0.0;					// moyenne du nviveau d'intensite de la peur des agents objectifs et experimentes
	
	list<habitantGenerique> listCraintifNonExperimente <-[];	// Liste des individus craintifs et non experimentes
	list<habitantGenerique> listCraintifExperimente <-[];		// Liste des individus craintifs et experimentes
	list<habitantGenerique> listOptimisteNonExperimente <-[];	// Liste des individus optimistes et non experimentes
	list<habitantGenerique> listOptimisteExperimente <-[];		// Litse des individus optimistes et experimentes
	list<habitantGenerique> listObjectifNonExperimente <-[];	// Liste des individus objectifs et non experimentes
	list<habitantGenerique> listObjectifExperimente <-[];		// Liste des individus objectifs et experimentes
	
	init{
		// Creation de nbreArbre arbres sains au départ
	 	create arbre number: nbreArbre
		{
		} 
		
		// Creation de nbreArbreFeu feu au départ
	 	create feu number: nbreFeu
		{
		}
		
		 create abri number: 1 
		{
			 location <-point(1, 1 );
		}
		
		create abri number: 1
		{
			location <-point(1, width_and_height_of_environment);
		}
		
		create abri number: 1 
		{
			location <-point(width_and_height_of_environment, 1 );
		}
		
		create abri number: 1
		{
			location <-point(width_and_height_of_environment, width_and_height_of_environment);
		}
		
		create batiment number: 10
		{
		}
		
		create habitantGenerique number: 10 with:[dangerFam::dangerFamNonFami, percepSubjectivity::percepSubjectivityPeur, color::#orange]; 		// creation agent craintif et non experimente
		create habitantGenerique number: 10 with:[dangerFam::dangerFamExp, percepSubjectivity::percepSubjectivityPeur,color::#moccasin]; 			// creation agent craintif et experimente
		create habitantGenerique number: 10 with:[dangerFam::dangerFamNonFami, percepSubjectivity::percepSubjectivityOpti,color::#yellow]; 			// creation agent optimiste et non experimente
		create habitantGenerique number: 10 with:[dangerFam::dangerFamExp, percepSubjectivity::percepSubjectivityOpti,color::#brown]; 				// creation agent optimiste et  experimente
		create habitantGenerique number: 10 with:[dangerFam::dangerFamNonFami, percepSubjectivity::percepSubjectivityObjectif,color::#violet]; 		// creation agent objectif et non experimente
		create habitantGenerique number: 10 with:[dangerFam::dangerFamExp, percepSubjectivity::percepSubjectivityObjectif,color::#indigo]{
			
		} 			// creation agent objectif et experimente
	}
	
	reflex MAJlistAgent{
		ask habitantGenerique where (each.dangerFam=dangerFamNonFami and each.percepSubjectivity=percepSubjectivityPeur){
			if(!(myself.listCraintifNonExperimente contains self)){
					
					add self to: myself.listCraintifNonExperimente;
					
				}
		}
		
		ask habitantGenerique where (each.dangerFam=dangerFamExp and each.percepSubjectivity=percepSubjectivityPeur){
			if(!(myself.listCraintifExperimente contains self)){
					
					add self to: myself.listCraintifExperimente;
					
				}
		}
		
		ask habitantGenerique where (each.dangerFam=dangerFamNonFami and each.percepSubjectivity=percepSubjectivityOpti){
			if(!(myself.listOptimisteNonExperimente contains self)){
					
					add self to: myself.listOptimisteNonExperimente;
					
				}
		}
		
		ask habitantGenerique where (each.dangerFam=dangerFamExp and each.percepSubjectivity=percepSubjectivityOpti){
			if(!(myself.listOptimisteExperimente contains self)){
					
					add self to: myself.listOptimisteExperimente;
					
				}
		}
		
		ask habitantGenerique where (each.dangerFam=dangerFamNonFami and each.percepSubjectivity=percepSubjectivityObjectif){
			if(!(myself.listObjectifNonExperimente contains self)){
					
					add self to: myself.listObjectifNonExperimente;
					
				}
		}
		
		
		ask habitantGenerique where (each.dangerFam=dangerFamExp and each.percepSubjectivity=percepSubjectivityObjectif){
			if(!(myself.listObjectifExperimente contains self)){
					
					add self to: myself.listObjectifExperimente;
					
				}
		}
		
	}
	
	reflex calculdesIntensitesDepeurMoyennesParProfil{
		
		//Agent CraintifNonExperimente
		loop h over: listCraintifNonExperimente{
			dangerEnvCraintifNonExperimente <- dangerEnvCraintifNonExperimente + h.dangerEnvSurjectif;
			fearEnvCraintifNonExperimente <- fearEnvCraintifNonExperimente + h.fearEnv;
		}
		if(listCraintifNonExperimente!=nil){
			dangerEnvCraintifNonExperimente <- dangerEnvCraintifNonExperimente / length(listCraintifNonExperimente);
			fearEnvCraintifNonExperimente <- fearEnvCraintifNonExperimente / length(listCraintifNonExperimente);
		}
		
		//dangerEnvCraintifNonExperimente <- mean(listCraintifNonExperimente collect(each.dangerEnvSurjectif));
		
		
		
		//Agent CraintifExperimente
		loop h over: listCraintifExperimente{
			dangerEnvCraintifExperimente <- dangerEnvCraintifExperimente + h.dangerEnvSurjectif;
			fearEnvCraintifExperimente <- fearEnvCraintifExperimente + h.fearEnv;
		}
		if(listCraintifExperimente!=nil){
			dangerEnvCraintifExperimente <- dangerEnvCraintifExperimente / length(listCraintifExperimente);
			fearEnvCraintifExperimente <- fearEnvCraintifExperimente / length(listCraintifExperimente);
		}
		
		
		//Agent OptimisteNonExperimente
		loop h over: listOptimisteNonExperimente{
			dangerEnvOptimisteNonExperimente <- dangerEnvOptimisteNonExperimente + h.dangerEnvSurjectif;
			fearEnvOptimisteNonExperimente <- fearEnvOptimisteNonExperimente + h.fearEnv;
		}
		
		dangerEnvOptimisteNonExperimente <- dangerEnvOptimisteNonExperimente / length(listOptimisteNonExperimente);
		fearEnvOptimisteNonExperimente <- fearEnvOptimisteNonExperimente / length(listOptimisteNonExperimente);
		
		//Agent OptimisteExperimente
		loop h over: listOptimisteExperimente{
			dangerEnvOptimisteExperimente <- dangerEnvOptimisteExperimente + h.dangerEnvSurjectif;
			fearEnvOptimisteExperimente <- fearEnvOptimisteExperimente + h.fearEnv;
		}
		if(listOptimisteExperimente!=nil){
			dangerEnvOptimisteExperimente <- dangerEnvOptimisteExperimente / length(listOptimisteExperimente);
			fearEnvOptimisteExperimente <- fearEnvOptimisteExperimente / length(listOptimisteExperimente);
		}
		
		
		//Agent ObjectifNonExperimente
		loop h over: listObjectifNonExperimente{
			dangerEnvObjectifNonExperimente <- dangerEnvObjectifNonExperimente + h.dangerEnvSurjectif;
			fearEnvObjectifNonExperimente <- fearEnvObjectifNonExperimente + h.fearEnv;
		}
		if(listObjectifNonExperimente!=nil){
			dangerEnvObjectifNonExperimente <- dangerEnvObjectifNonExperimente / length(listObjectifNonExperimente);
			fearEnvObjectifNonExperimente <- fearEnvObjectifNonExperimente / length(listObjectifNonExperimente);
		}
		
		
		//Agent ObjectifExperimente
		loop h over: listObjectifExperimente{
			dangerEnvObjectifExperimente <- dangerEnvObjectifExperimente + h.dangerEnvSurjectif;
			fearEnvObjectifExperimente <- fearEnvObjectifExperimente + h.fearEnv;
		}
		if(listObjectifExperimente!=nil){
			dangerEnvObjectifExperimente <- dangerEnvObjectifExperimente / length(listObjectifExperimente);
			fearEnvObjectifExperimente <- fearEnvObjectifExperimente / length(listObjectifExperimente);
		}
		
		
	}
}


// Tous les agents succeptibles de se deplacer ou meme statiques heritent de ce specie
 species position
	{
		int x;
		int y;
		rgb color ;
	} 
	
	//Habitant fictif
 species habitantGenerique parent: position
	{
		int size const:true <- 2; 										// taille d'un habitant
		int rayonPerception <- 0;										// rayon de perception d'un habiatant  a 360 degre
		float fearEnv <- 0.0;											// le niveau d'intensite de la peur chez un individu
		float dangerFam const:true <- 0.5 min:0.01 max:1.0;				// la familiarite de l'individu avec le danger (plus ce cof est proche de 1, plus l'individu est familier. Dans le cas contraire cad proche 0 il est peu familier)
		float percepSubjectivity const:true <- 0.8 min:0.01 max:10.0;	// la perception surjective d'un individu face a la dangeriosite de l'enviroennement (si ce cof est inferieur a 1, alors l'agent est optimiste et prend moins consceince du danger. Sinon il est pessimiste et peureux)
		bool effetBascule <- false;										// permet de savoir si l'individu a pris conscience du danger
		float dangerEnvObjectif <- 0.0;									// niveau de dangeriosite objective de l'environnment vu par un individu
		float dangerEnvSurjectif <- 0.0;								// niveau de dangeriosite sujective de l'environnment vu par un individu
		
		list<feu> listFeu <- [];
		
		
		init
		{
			rayonPerception <- PerceptionRange;
			x <- rnd(width_and_height_of_environment - 2 * size) + size;
			y <- rnd(width_and_height_of_environment - 2 * size) + size;
			location <- point(x, y);
		}
		
		
		reflex MiseAJourNiveauPeur when: !empty(feu at_distance rayonPerception){
			
			ask feu at_distance rayonPerception{
				
				if(!(myself.listFeu contains self)){
					
					add self to: myself.listFeu;
					
				}
				
			}
			
			float distance <-0.0;    			// declaration d'une variable temporaire pour le calcul de la distance de l'individu avec un foyer de feu
			list<feu> listFeuPriorise <-[];		// priorisation des foyers de feu
			
			if (listFeu!=nil){
				float dangerouness <-0.0;
				loop f over: listFeu{
				
					// Pemier test en considerant le numero d'apparition du feu
					distance <- distance_to(self,f);// sqrt((self.location.x - f.location.x) * (self.location.x - f.location.x) + (self.location.y - f.location.y) * (self.location.y - f.location.y));
					
					dangerouness <-f.size / (((listFeu index_of f) +1) * distance); // calcul de la dangeriosite objective d'un element feu
					
					dangerEnvObjectif <- dangerEnvObjectif + dangerouness; 			// calcul de la dangeriosite objective de l'environnement
			
				}
			}
			
			write("Apres la boucle");
			write(dangerEnvObjectif);
			
			dangerEnvSurjectif <- percepSubjectivity * dangerEnvObjectif;       // calcul de la dangeriosite sujective de l'environnement vu par un individu
			write("Dangeriosite surjective est : ");
			write(dangerEnvSurjectif);
			
			fearEnv <- 1 / (1+ exp(6-(1-dangerFam) * dangerEnvSurjectif));		// calcul de l'intensite de la peur d'un individu
			write("L'intensite de la peur est : ");
			write(fearEnv);
			
		}

		aspect base
		{
			draw circle(size) color:color;
		}


	}

// ceci est un feu avec ses activites 
species feu parent: position skills: [moving]{
		int size <- 1 + rnd(2); 					// taille du feu correspondant a son diametre. Diametre compris entre 1 et 3 cases
		int temp <- 0;								// temps necessaire pour bruler une surface donnee
		int numeroOrdre <- 0;						// priorisation des foyers de feu en fonction de leur taille a egale distance
		init
		{
			x <- rnd(width_and_height_of_environment - 2 * size) + size;
			y <- rnd(width_and_height_of_environment - 2 * size) + size;
			location <- point(x, y);
			color <- rgb(255, 225+rnd(30), 0);
		}

		/*
		reflex deplacementSousEffetVent {
			do wander amplitude: 45 speed:0.3;
		}
		*/

		reflex propager when: !empty(arbre at_distance (intervalPropagation)) or !empty(batiment at_distance (intervalPropagation))
		{
			ask arbre at_distance (intervalPropagation)
			{
				if (flip(0.9))
				{
					create feu number: 1 with: (location: { self.location.x, self.location.y }, size:self.size+myself.size);
					do die;
					
				}

			}
			
			ask batiment at_distance (intervalPropagation)
			{
				if (flip(0.9))
				{
					create feu number: 1 with: (location: { self.location.x, self.location.y }, size:self.size+myself.size);
					do die;
					
				}

			}

		}


		reflex bruler when: temp <= dureeCremationArbre
		{
			temp <- temp + 1;
			color <- rgb(255, 200+rnd(55), 0);
		}

		reflex mourir when: temp = dureeCremationArbre
		{
			create arbreMort number: 1 with: (location: { self.location.x, self.location.y });
			do die;
		} 
		
		
 		aspect base
		{
			draw circle(size) color:color;
		}
	}


// ceci est un arbre sain qui est vert et sa taille varie entre 1 et 2 cases
 species arbre parent: position
{
	int size <- 1 + rnd(1);
	init
	{
		x <- rnd(width_and_height_of_environment - 2 * size) + size;
		y <- rnd(width_and_height_of_environment - 2 * size) + size;
		location <- point(x, y);
	}

	aspect base
	{
		draw circle(size) color:#forestgreen;
	}

} 

// ceci est un batiment 
species batiment parent: position
{
	int size <- 10 + rnd(5);
	init
	{
		x <- rnd(width_and_height_of_environment - 2 * size) + size;
		y <- rnd(width_and_height_of_environment - 2 * size) + size;
		location <- point(x, y);
	}

	aspect base
	{
		draw square(size) color:#gray;
	}

} 


species abri parent: position
{
	int size <- 50 ;
	init
	{
		
	}

	aspect base
	{
		draw square(size) color:#blue;
	}

} 


//arbre mort il n'a pas grand chose comme propriété juste sa taille et sa couleur qui change et devient cendre
 species arbreMort parent: position
{
	int size <- 1;
	aspect base
	{
		draw circle(size) color:#gainsboro;
	}

}

species batimentDetruit parent: position
{
	int size <- 1;
	
	aspect base
	{
		draw square(size) color:#gainsboro;
	}

} 



experiment declenchementSansPropagationFeu type: gui {
	
	parameter "nombre d'arbres" var: nbreArbre <- 100 min: 50 max: 500 category: "Environment"; 				// parametre d'entree pour definir le nombre d'arbre a creer au debut de la simulation. Par defaut c'est 100
	parameter "nombre de feux" var: nbreFeu <- 50 min: 10 max: 500 category: "Environment";						// parametre d'entree pour definir le nombre de feu au debut de la simulation. par defaut 10 foyers sont crees
	parameter "nombre de batiments" var: nbreBatiment <- 25 min: 5 max: 50 category: "Environment";				// parametre d'entree pour definir le nombre de batiment  a creer au debut de la simulation. Par defaut c'est 25
	parameter "intervalle de propagation" var: intervalPropagation <- 20 min: 5 max: 100 category: "Feu";		// parametre d'entree pour definir le nombre de batiment  a creer au debut de la simulation. Par defaut c'est 25
	
	parameter "perception d'un individu peureux" var:percepSubjectivityPeur <- 3.0 		category: "Habitant";	// parametre d'entree pour definir la perception sujective de la dangeriosite du milieu par un agent pareux 
	parameter "familiarite d'un individu non familier" var:dangerFamNonFami <- 0.1 		category: "Habitant";	// parametre d'entree pour definir le coefficient de familiarite au danger  par un agent non familier 
	parameter "familiarite d'un individu experimente" var:dangerFamExp <- 0.8 			category: "Habitant";	// parametre d'entree pour definir lle coefficient de familiarite au danger  par un agent familier 
	parameter "perception d'un individu optimiste" var:percepSubjectivityOpti <- 0.5 	category: "Habitant";	// parametre d'entree pour definir la perception sujective de la dangeriosite du milieu par un agent optimiste 
	parameter "perception d'un individu objectif" var:percepSubjectivityObjectif <- 1.0 category: "Habitant";	// parametre d'entree pour definir la perception sujective de la dangeriosite du milieu par un agent objectif 
	parameter "champ de vision d'un individu" var:PerceptionRange <- 50					category: "Habitant";	// parametre d'entree pour definir le champ de vison d'un habitant
			
	
	output {		
		
		display main_display
		{
			
			species arbre aspect: base;
			species feu aspect: base;
			species batiment aspect: base;
			species abri aspect: base;
			species arbreMort aspect: base;
			species batimentDetruit aspect: base;
			species habitantGenerique aspect: base;
		}
		
		monitor "Nombre de feu" value: nb_feu;
		
		display ChartDangeriositeEnvironnment
		{
			chart "Dangeriosite objective de l'environnement" {
				data "nombre de foyers de feu" value: length(feu) color: #black;
			}
		}
		
		/* 
		display ChartCraintifNonExperimente
		{
			chart " Intensite de la peur agent craintif non experimente " type: xy{
				data "Intensite de la peur" value: fearEnvCraintifNonExperimente color: #green ;
			}
			
			/* 
			chart " Dangeriosite du milieu " type: series background: #white position: {0,0.66} size:{1,0.33}x_range: 1000{
				data "Dangeriosite du milieu" value: dangerEnvCraintifNonExperimente color: #red ;
			}
			
			*/	
		//}
		/* 
		display ChartCraintifExperimente
		{
			chart " Intensite de la peur agent craintif experimente " type: xy{
				data "Intensite de la peur" value: fearEnvCraintifExperimente color: #green ;
			}
			
			/* 
			chart " Dangeriosite du milieu " type: series background: #white position: {0,0.66} size:{1,0.33}x_range: 1000{
				data "Dangeriosite du milieu" value: dangerEnvCraintifExperimente color: #red ;
			}*/
			
	//	}
		/*
		display ChartOptimisteNonExperimente
		{
			chart " Intensite de la peur agent optimiste non experimente" type: xy{
				data "Intensite de la peur" value: fearEnvOptimisteNonExperimente color: #green ;
			}
			
			/*
			chart " Dangeriosite du milieu " type: series background: #white position: {0,0.66} size:{1,0.33}x_range: 1000{
				data "Dangeriosite du milieu" value: dangerEnvOptimisteNonExperimente color: #red ;
			}
			*/	
		//}
		
		/*
		display ChartOptimisteExperimente
		{
			chart " Intensite de la peur agent optimiste experimente " type: xy{
				data "Intensite de la peur" value: fearEnvOptimisteExperimente color: #green ;
			}
			
			/* 
			chart " Dangeriosite du milieu " type: series background: #white position: {0,0.66} size:{1,0.33}x_range: 1000{
				data "Dangeriosite du milieu" value: dangerEnvOptimisteExperimente color: #red ;
			}	*/
		//}
		
		/*
		display ChartObjectifNonExperimente
		{
			chart " Intensite de la peur agent objectif non experimente " type: xy{
				data "Intensite de la peur" value: fearEnvObjectifNonExperimente color: #green ;
			}
			
			/* 
			chart " Dangeriosite du milieu agent objectif non experimente " type: series background: #white position: {0,0.66} size:{1,0.33}x_range: 1000{
				data "Dangeriosite du milieu " value: dangerEnvObjectifNonExperimente color: #red ;
			}	
			*/
		//}
		
		/*
		display ChartObjectifExperimenteIntensitePeur
		{
			
			chart " Intensite de la peur " {
				data "Intensite de la peur" value: fearEnvObjectifExperimente color: #green ;
			}
			
			/*chart " Intensite de peur et Dangeriosite du milieu pour individu Objectif Experimente " type: series background: #white position: {0,0.66} size:{1,0.33}x_range: 1000{
				data "Dangeriosite du milieu" value: dangerEnvObjectifExperimente color: #red ;
			}*/
				
		//}
		
		/*
		display ChartObjectifExperimenteDangeriositeEnv
		{
			
			/*chart " Intensite de la peur " {
				data "Intensite de la peur" value: fearEnvObjectifExperimente color: #green ;
			}*/
			
			//chart " Intensite de peur et Dangeriosite du milieu pour individu Objectif Experimente " type:xy{
		//		data "Dangeriosite du milieu" value: dangerEnvObjectifExperimente color: #red ;
		//	}	
				
		//}
		
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
