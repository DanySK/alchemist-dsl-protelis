/*
* generated by Xtext
*/
package it.unibo.alchemist.language.protelis;

/**
 * Initialization support for running Xtext languages 
 * without equinox extension registry
 */
public class ProtelisDSLStandaloneSetup extends ProtelisDSLStandaloneSetupGenerated{

	public static void doSetup() {
		new ProtelisDSLStandaloneSetup().createInjectorAndDoEMFRegistration();
	}
}
