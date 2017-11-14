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
	int intervalPropagation;											// intervalle de propagation du feu
	int dureeCremationArbre const: true <- 1000; 				// temps nécessaire pourqu'un arbre se consomme totalement
 	int dureeCremationBatiment const: true <- 1500; 			// temps nécessaire pourqu'un batiment se consomme totalement
 

	
	
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
 species habitantFictif parent: position
	{
		int size const:true <- 2; 										// taille d'un habitant
		int rayonPerception <- 50;										// rayon de perception d'un habiatant  a 360 degre
		float fearEnv <- 0.0;											// le niveau d'intensite de la peur chez un individu
		float dangerFam const:true <- 0.0 min:0.01 max:1.0;				// la familiarite de l'individu avec le danger (plus ce cof est proche de 1, plus l'individu est familier. Dans le cas contraire cad proche 0 il est peu familier)
		float percepSubjectivity const:true <- 0.0 min:0.01 max:10.0;	// la perception surjective d'un individu face a la dangeriosite de l'enviroennement (si ce cof est inferieur a 1, alors l'agent est optimiste et prend moins consceince du danger. Sinon il est pessimiste et peureux)
		bool effetBascule <- false;										// permet de savoir si l'individu a pris conscience du danger

		init
		{
		
			x <- rnd(width_and_height_of_environment - 2 * size) + size;
			y <- rnd(width_and_height_of_environment - 2 * size) + size;
			location <- point(x, y);
		}

		aspect base
		{
			draw circle(size);
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
species batiment parent: position control: fsm
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


species abri parent: position control: fsm
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
		}
		
		display ChartDangeriositeEnvironnment
		{
			chart "Dangeriosite objective de l'environnement" {
				data "nombre de foyers de feu" value: length(feu) color: #black;
			}
		}
 		
		}
	
}

