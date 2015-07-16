//
//  ViewController.m
//  MBXMapKitDemo
//
//  Created by Brad Leege on 7/15/15.
//
//

#import "ViewController.h"
#import "MBXMapKit.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (nonatomic) MBXRasterTileOverlay *rasterOverlay;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.

    // Set the Mapbox access token for API access
    //
    [MBXMapKit setAccessToken:@"pk.eyJ1IjoiYmxlZWdlIiwiYSI6IjFmMDM3ODUwYzIwNDNlNzFlZmE5N2VlZTRlYzkxYzMwIn0.IJaNkbzTUjMigdd_jm5kWg"];

    _mapView.delegate = self;

    _rasterOverlay = [[MBXRasterTileOverlay alloc] initWithMapID:@"bleege.mnl6171l"];

    _rasterOverlay.delegate = self;

    [_mapView addOverlay:_rasterOverlay];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - MKMapViewDelegate protocol implementation

- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay
{
    // This is boilerplate code to connect tile overlay layers with suitable renderers
    //
    if ([overlay isKindOfClass:[MBXRasterTileOverlay class]])
    {
        MBXRasterTileRenderer *renderer = [[MBXRasterTileRenderer alloc] initWithTileOverlay:overlay];
        return renderer;
    }
    return nil;
}


- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    // This is boilerplate code to connect annotations with suitable views
    //
    if ([annotation isKindOfClass:[MBXPointAnnotation class]])
    {
        static NSString *MBXSimpleStyleReuseIdentifier = @"MBXSimpleStyleReuseIdentifier";
        MKAnnotationView *view = [mapView dequeueReusableAnnotationViewWithIdentifier:MBXSimpleStyleReuseIdentifier];
        if (!view)
        {
            view = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:MBXSimpleStyleReuseIdentifier];
        }
        view.image = ((MBXPointAnnotation *)annotation).image;
        view.canShowCallout = YES;
        return view;
    }
    return nil;
}

#pragma mark - MBXRasterTileOverlayDelegate implementation

- (void)tileOverlay:(MBXRasterTileOverlay *)overlay didLoadMetadata:(NSDictionary *)metadata withError:(NSError *)error
{
    // This delegate callback is for centering the map once the map metadata has been loaded
    //
    if (error)
    {
        NSLog(@"Failed to load metadata for map ID %@ - (%@)", overlay.mapID, error?error:@"");
    }
    else
    {
        [_mapView mbx_setCenterCoordinate:overlay.center zoomLevel:overlay.centerZoom animated:NO];
    }
}


- (void)tileOverlay:(MBXRasterTileOverlay *)overlay didLoadMarkers:(NSArray *)markers withError:(NSError *)error
{
    // This delegate callback is for adding map markers to an MKMapView once all the markers for the tile overlay have loaded
    //
    if (error)
    {
        NSLog(@"Failed to load markers for map ID %@ - (%@)", overlay.mapID, error?error:@"");
    }
    else
    {
        [_mapView addAnnotations:markers];
    }
}

@end
