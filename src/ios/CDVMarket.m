//
//  CDVMarket.h
//
// Created by Miguel Revetria miguel@xmartlabs.com on 2014-03-17.
// Modified by Brangers on 2025-04-14
// License Apache 2.0

#import "CDVMarket.h"

@implementation CDVMarket

- (void)pluginInitialize
{
}

- (void)open:(CDVInvokedUrlCommand *)command
{
    [self.commandDelegate runInBackground:^{
        NSArray *args = command.arguments;
        NSString *appId = [args objectAtIndex:0];
        
        CDVPluginResult *pluginResult;
        if (appId) {
            // Construction de l'URL de l'App Store
            NSString *urlString = [NSString stringWithFormat:@"itms-apps://itunes.apple.com/app/%@", appId];
            NSURL *url = [NSURL URLWithString:urlString];
            
            // Exécution sur le thread principal pour les opérations UI
            dispatch_async(dispatch_get_main_queue(), ^{
                if ([[UIApplication sharedApplication] respondsToSelector:@selector(openURL:options:completionHandler:)]) {
                    // Utilisation de la nouvelle méthode pour iOS 10+
                    [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:^(BOOL success) {
                        if (!success) {
                            NSLog(@"Erreur lors de l'ouverture de l'URL: %@", url);
                        }
                    }];
                } else {
                    // Méthode rétrocompatible pour les versions antérieures
                    BOOL success = [[UIApplication sharedApplication] openURL:url];
                    if (!success) {
                        NSLog(@"Erreur lors de l'ouverture de l'URL (méthode dépréciée) : %@", url);
                    }
                }
            });
            
            pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
        } else {
            pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"Identifiant d'application invalide : null trouvé"];
        }
        
        [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
    }];
}

@end
