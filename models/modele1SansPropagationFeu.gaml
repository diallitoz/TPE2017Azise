/**
* Name: modele1SansPropagationFeu
* Author: DIALLO Azise Oumar
* Description: 1er modele simpliste avec les foyers de feu sans propagation
* Tags: Tag1, Tag2, TagN
*/

model modele1SansPropagationFeu

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
 	
 	 int nb_feu <-0;	
 	
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
		/*
		ask target: nbreFeu among (arbre as list)
		{
			set state value: 'burning';
		}
		*/
		ask (nbreFeu among arbre) {
        	state<-'burning';
        }

	}
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




experiment FeuSansPropagation type: gui {
	
	parameter "nombre d'arbres" var: nbreArbre <- 100 min: 50 max: 500 category: "Environment"; 				// parametre d'entree pour definir le nombre d'arbre a creer au debut de la simulation. Par defaut c'est 100
	parameter "nombre de feux" var: nbreFeu <- 10 min: 10 max: 500 category: "Environment";						// parametre d'entree pour definir le nombre de feu au debut de la simulation. par defaut 10 foyers sont crees
	parameter "nombre de batiments" var: nbreBatiment <- 25 min: 5 max: 50 category: "Environment";				// parametre d'entree pour definir le nombre de batiment  a creer au debut de la simulation. Par defaut c'est 25
	parameter "intervalle de propagation" var: intervalPropagation <- 20 min: 5 max: 100 category: "Feu";		// parametre d'entree pour definir l'intervalle de propagation
	output {		
		
		display main_display
		{
			
			species arbre aspect: base;
			species batiment aspect: base;
			species detruit aspect: base;
		}
		
	}
}
