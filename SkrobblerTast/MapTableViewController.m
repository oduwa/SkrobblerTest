//
//  MapTableViewController.m
//  SkrobblerTast
//
//  Created by Odie Edo-Osagie on 14/09/2016.
//  Copyright © 2016 Odie Edo-Osagie. All rights reserved.
//

#import "MapTableViewController.h"
#import "NVHTarGzip.h"
#import <SKMaps/SKMaps.h>

@interface MapTableViewController (){
    UIActivityIndicatorView *activityIndicator;
}

@end

@implementation MapTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    activityIndicator.center = self.view.center;
    [self.view addSubview:activityIndicator];
    [activityIndicator setHidesWhenStopped:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"DOWNLOADING..");
    dispatch_async(dispatch_get_main_queue(), ^{
        [activityIndicator startAnimating];
    });
    
    
    dispatch_queue_t q = dispatch_queue_create("DOWNLOAD QUEUE",NULL);
    dispatch_async(q, ^{
        if(indexPath.row == 0){
            [self download:@"http://test.sumitanantwar.com/maps/GBCITY04.skm" withName:@"London"];
        }
        else if(indexPath.row == 1){
            [self download:@"http://oduwa.github.io/Hosting/NG.skm" withName:@"Nigeria"];
        }
        else{
            
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [activityIndicator stopAnimating];
            [tableView deselectRowAtIndexPath:indexPath animated:YES];
        });
    });
    
}

- (void) download:(NSString *)remote withName:(NSString *)name
{
    NSString *stringURL = remote;
    NSURL  *url = [NSURL URLWithString:stringURL];
    NSData *urlData = [NSData dataWithContentsOfURL:url];
    NSArray       *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString  *documentsDirectory = [paths objectAtIndex:0];
    NSString  *filePath = [NSString stringWithFormat:@"%@/%@", documentsDirectory,[NSString stringWithFormat:@"%@.skm",name]];
    [urlData writeToFile:filePath atomically:YES];
    NSLog(@"DONE At %@", documentsDirectory);
    
    SKAddPackageResult res = [[SKMapsService sharedInstance].packagesManager addOfflineMapPackageNamed:name inContainingFolderPath:documentsDirectory];
    if(res == SKAddPackageResultSuccess){
        NSLog(@"SKAddPackageResultSuccess");
    }
    else if(res == SKAddPackageResultMissingTxgFile){
        NSLog(@"SKAddPackageResultMissingTxgFile");
    }
    else if(res == SKAddPackageResultMissingSkmFile){
        NSLog(@"SKAddPackageResultMissingSkmFile");
    }
    else if(res == SKAddPackageResultMissingNgiFile){
        NSLog(@"SKAddPackageResultMissingNgiFile");
    }
    else if(res == SKAddPackageResultMissingNgiDatFile){
        NSLog(@"SKAddPackageResultMissingNgiDatFile");
    }
    else if(res == SKAddPackageResultCannotEraseFile){
        NSLog(@"SKAddPackageResultCannotEraseFile");
    }
    else{
        NSLog(@"COMPOUND RESULT %ld", (long)res);
    }
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
