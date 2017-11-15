/**
* Name: DeuxiemeVersionG17
* Author: DIALLO Azise Oumar
* Description: Implementation du modele mathematique relatif a la condition du declenchement de la peur face au danger
* Tags: Tag1, Tag2, TagN
*/

model DeuxiemeVersionG17

/* Insert your model definition here */


global {

	int width_and_height_of_environment const: true <- 1000; 	// lageur de la de l'environnement
	geometry shape <- rectangle(width_and_height_of_environment # m, width_and_height_of_environment # m);
	int nbreArbre;												// nombre d'arbre
	int nbreBatiment;											// nombre de batiment
	int nbreFeu;												// nombre de feu au debut
	int intervalPropagation;									// intervalle de propagation du feu
	int dureeCremationArbre const: true <- 1000; 				// temps nécessaire pourqu'un arbre se consomme totalement
 	int dureeCremationBatiment const: true <- 1500; 			// temps nécessaire pourqu'un batiment se consomme totalement
 	
 	int nb_feu -> {length (feu)};								// nombre de feu crees au cours de la simulation


	
	float percepSubjectivityPeur <- 3.0;		// peureux
	
	float dangerFamNonFami  <- 0.1;				// non familier
	
	float dangerFamExp  <- 0.8;					// familier
	
	float percepSubjectivityOpti <- 0.5;		// optimiste
		
	float percepSubjectivityObjectif <- 1.0;	// objectif
	
	
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
		
		create habitantGenerique number: 2 with:[dangerFam::dangerFamNonFami, percepSubjectivity::percepSubjectivityPeur, color::#orange]; 		// creation agent craintif et non experimente
		create habitantGenerique number: 2 with:[dangerFam::dangerFamExp, percepSubjectivity::percepSubjectivityPeur,color::#moccasin]; 			// creation agent craintif et experimente
		create habitantGenerique number: 2 with:[dangerFam::dangerFamNonFami, percepSubjectivity::percepSubjectivityOpti,color::#yellow]; 		// creation agent optimiste et non experimente
		create habitantGenerique number: 2 with:[dangerFam::dangerFamExp, percepSubjectivity::percepSubjectivityOpti,color::#brown]; 			// creation agent optimiste et  experimente
		create habitantGenerique number: 2 with:[dangerFam::dangerFamNonFami, percepSubjectivity::percepSubjectivityObjectif,color::#violet]; 	// creation agent objectif et non experimente
		create habitantGenerique number: 2 with:[dangerFam::dangerFamExp, percepSubjectivity::percepSubjectivityObjectif,color::#indigo]; 	// creation agent objectif et experimente
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
		int rayonPerception <- 50;										// rayon de perception d'un habiatant  a 360 degre
		float fearEnv <- 0.0;											// le niveau d'intensite de la peur chez un individu
		float dangerFam const:true <- 0.5 min:0.01 max:1.0;				// la familiarite de l'individu avec le danger (plus ce cof est proche de 1, plus l'individu est familier. Dans le cas contraire cad proche 0 il est peu familier)
		float percepSubjectivity const:true <- 0.8 min:0.01 max:10.0;	// la perception surjective d'un individu face a la dangeriosite de l'enviroennement (si ce cof est inferieur a 1, alors l'agent est optimiste et prend moins consceince du danger. Sinon il est pessimiste et peureux)
		bool effetBascule <- false;										// permet de savoir si l'individu a pris conscience du danger
		float dangerEnvSurjectif <- 0.0;								// niveau de dangeriosite sujective d'un individu
		
		list<feu> listFeu <- [];
		
		
		init
		{
		
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
			
			float distance <-0.0;    // declaration d'une variable temporaire pour le calcul de la distance de l'individu avec un foyer de feu
			list<feu> listFeuPriorise <-[];
			loop f over: listFeu{
				
					// Pemier test en considerant le numero d'apparition du feu
					distance <- sqrt((self.location.x - f.location.x) * (self.location.x - f.location.x) + (self.location.y - f.location.y) * (self.location.y - f.location.y));
					dangerEnvSurjectif <- dangerEnvSurjectif + (f.size / ((listFeu index_of f) +1) * distance);
					write(dangerEnvSurjectif);
			
			}
			write("Apres la boucle");
			write(dangerEnvSurjectif);
			dangerEnvSurjectif <- percepSubjectivity * dangerEnvSurjectif;
			write("Dangeriosite surjective");
			write(dangerEnvSurjectif);
			fearEnv <- 1 / (1+ exp(6-(1-dangerFam) * dangerEnvSurjectif));
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


		reflex deplacementSousEffetVent {
			do wander amplitude: 45 speed:0.3;
		}

		reflex propager when: !empty(arbre at_distance (intervalPropagation)) or !empty(batiment at_distance (intervalPropagation))
		{
			ask arbre at_distance (intervalPropagation)
			{
				if (flip(0.9))
				{
					create feu number: 1 with: (location: { self.location.x, self.location.y }, size:self.size);
					do die;
					
				}

			}
			
			ask batiment at_distance (intervalPropagation)
			{
				if (flip(0.9))
				{
					create feu number: 1 with: (location: { self.location.x, self.location.y }, size:self.size);
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



experiment declenchement type: gui {
	
	parameter "nombre d'arbres" var: nbreArbre <- 100 min: 50 max: 500 category: "Environment"; 				// parametre d'entree pour definir le nombre d'arbre a creer au debut de la simulation. Par defaut c'est 100
	parameter "nombre de feux" var: nbreFeu <- 10 min: 5 max: 100 category: "Environment";						// parametre d'entree pour definir le nombre de feu au debut de la simulation. par defaut 10 foyers sont crees
	parameter "nombre de batiments" var: nbreBatiment <- 25 min: 5 max: 50 category: "Environment";				// parametre d'entree pour definir le nombre de batiment  a creer au debut de la simulation. Par defaut c'est 25
	parameter "intervalle de propagation" var: intervalPropagation <- 20 min: 5 max: 100 category: "Feu";		// parametre d'entree pour definir le nombre de batiment  a creer au debut de la simulation. Par defaut c'est 25
	
		
	
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
		
		display ChartDangeriositeEnvironnment
		{
			chart "Dangeriosite objective de l'environnement" {
				data "nombre de foyers de feu" value: length(feu) color: #black;
			}
			
			
			chart " Niveau de peur de differents profils " type: series background: #white position: {0,0.66} size:{1,0.33}x_range: 1000{
				data "craintif et non experimente" value: first(habitantGenerique where (each.dangerFam=dangerFamNonFami and each.percepSubjectivity=percepSubjectivityPeur)).fearEnv color: #green ;
				data "craintif et experimente" value: first(habitantGenerique where (each.dangerFam=dangerFamExp and each.percepSubjectivity=percepSubjectivityPeur)).fearEnv color: #red ;
				data "optimiste et non experimente" value: first(habitantGenerique where (each.dangerFam=dangerFamNonFami and each.percepSubjectivity=percepSubjectivityOpti)).fearEnv color: #yellow ;
				data "optimiste et experimente" value: first(habitantGenerique where (each.dangerFam=dangerFamExp and each.percepSubjectivity=percepSubjectivityOpti)).fearEnv color: #blue ;
				data "objectif et non experimente" value: first(habitantGenerique where (each.dangerFam=dangerFamNonFami and each.percepSubjectivity=percepSubjectivityObjectif)).fearEnv color: #brown ;
				data "objectif et experimente" value: first(habitantGenerique where (each.dangerFam=dangerFamExp and each.percepSubjectivity=percepSubjectivityObjectif)).fearEnv color: #violet ;
			}
			
			
		}
	}
}

