//
//  FPGridViewController.m
//  FlickrPic
//
//  Created by Gaurav Mishra on 09/08/18.
//  Copyright © 2018 Gaurav Mishra. All rights reserved.
//

#import "FPGridViewController.h"
#import "FPConstants.h"
#import "NSURLComponents+FPURLComponentsAdditions.h"
#import "AppDelegate.h"
#import "UINavigationBar+FPUIAdditons.h"
#import "FPJSONConstants.h"
#import "FPPhoto+CoreDataProperties.h"
#import "FPSearchDetail+CoreDataClass.h"
#import "FPDataParser.h"
#import "FPGridCollectionViewCell.h"
#import "FPImageManager.h"
#import "FPGridCollectionFooterView.h"
#import "FPDetailViewController.h"

static CGFloat const SearchBarHeight = 44.0f;
static NSString *const SearchMethodName = @"flickr.photos.search";
static NSString *const PageTitle = @"Image Search";
static NSString *const PlaceHolderText = @"Enter text that comes to your mind";
static NSString *const PicsCollectionViewCellIdentifier = @"PicsCollectionViewCellIdentifier";
static NSInteger const PerPagePhotosCount = 21;
static CGFloat const PixelWidthBetweenItems = 4.0f;
static CGFloat const ItemCountInOneLine = 3.0f;
static NSString *const PicsCollectionViewFooterViewIdentifier = @"PicColectionViewFooterViewIdentifier";

@interface FPGridViewController () <UISearchBarDelegate, UICollectionViewDataSource, UICollectionViewDelegate, NSFetchedResultsControllerDelegate> {
    NSInteger pageCount;
    NSString *searchBarText;
}

@property (nonatomic) UICollectionView *picsCollectionView;
@property (nonatomic) UISearchBar *searchBar;
@property (nonatomic) AppDelegate *appD;
@property (nonatomic) NSManagedObjectContext *managedObjectContext;
@property (nonatomic) FPDataParser *dataParser;
@property (nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic) FPImageManager *imageManager;
@property (nonatomic, assign) BOOL isLoadingNewPage;

@end

@implementation FPGridViewController

@synthesize managedObjectContext = _managedObjectContext;

- (instancetype)initWithManagedObjectContext:(NSManagedObjectContext *)managedObjectContext {
    self = [super init];
    if (self) {
        _appD = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        _managedObjectContext = managedObjectContext;
        _searchBar = [[UISearchBar alloc] init];
        _imageManager = _appD.imageManager;
        UICollectionViewFlowLayout *collectionViewLayout = [[UICollectionViewFlowLayout alloc] init];
        [collectionViewLayout setSectionInset:UIEdgeInsetsMake(PixelWidthBetweenItems,
                                                               PixelWidthBetweenItems,
                                                               PixelWidthBetweenItems,
                                                               PixelWidthBetweenItems)];
        [collectionViewLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
        _picsCollectionView = [[UICollectionView alloc]
                               initWithFrame:CGRectMake(0,
                                                        SearchBarHeight,
                                                        [UIScreen mainScreen].bounds.size.width,
                                                        [UIScreen mainScreen].bounds.size.height - SearchBarHeight - [UIApplication sharedApplication].statusBarFrame.size.height)
                               collectionViewLayout:collectionViewLayout];
        _dataParser = [[FPDataParser alloc] init];
    }
    return self;
}

- (void)loadView {
    [super loadView];
    CGRect collectionViewFrame = self.picsCollectionView.frame;
    collectionViewFrame.size.height -= self.navigationController.navigationBar.frame.size.height;
    
    self.picsCollectionView.frame = collectionViewFrame;
    self.searchBar.frame = CGRectMake(self.view.frame.origin.x,
                                      self.view.frame.origin.y,
                                      [UIScreen mainScreen].bounds.size.width,
                                      SearchBarHeight);
    [self.view addSubview:self.searchBar];
    [self.view addSubview:self.picsCollectionView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    pageCount = 1;
    [self.navigationItem setTitle:PageTitle];
    [self.navigationController.navigationBar setBottomBorderColor:[UIColor colorWithRed:51.0f/255.0f
                                                                                  green:51.0f/255.0f
                                                                                   blue:51.0f/255.0f
                                                                                  alpha:1.0] height:1];
    
    [self customiseSearchBar];
    self.picsCollectionView.dataSource = self;
    self.picsCollectionView.delegate = self;
    [self.picsCollectionView registerClass:[FPGridCollectionViewCell class]
                forCellWithReuseIdentifier:PicsCollectionViewCellIdentifier];
    [self.picsCollectionView registerClass:[FPGridCollectionFooterView class]
                forSupplementaryViewOfKind:UICollectionElementKindSectionFooter
                       withReuseIdentifier:PicsCollectionViewFooterViewIdentifier];
    
}

- (void)customiseSearchBar {
    self.searchBar.showsCancelButton = YES;
    self.searchBar.delegate = self;
    self.searchBar.placeholder = PlaceHolderText;
    
    [[UIBarButtonItem appearanceWhenContainedInInstancesOfClasses:@[[UISearchBar class]]]
     setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithRed:31.0f/255.0f
                                                                             green:147.0f/255.0f
                                                                              blue:243.0f/255.0f
                                                                             alpha:1.0],
                              NSFontAttributeName:[UIFont fontWithName:ApplicationFontName
                                                                  size:12.0f]}
     forState:UIControlStateNormal];
    [[UIBarButtonItem appearanceWhenContainedInInstancesOfClasses:@[[UISearchBar class]]] setTitle:@"Search"];
    
    [self.searchBar setBarTintColor:[UIColor colorWithRed:51.0f/255.0f
                                                    green:51.0f/255.0f
                                                     blue:51.0f/255.0f
                                                    alpha:1.0]];
    self.searchBar.layer.borderColor = [[UIColor colorWithRed:51.0f/255.0f
                                                        green:51.0f/255.0f
                                                         blue:51.0f/255.0f
                                                        alpha:1.0] CGColor];
    for (id object in [[[self.searchBar subviews] objectAtIndex:0] subviews])
    {
        if ([object isKindOfClass:[UITextField class]])
        {
            UITextField *textFieldObject = (UITextField *)object;
            textFieldObject.layer.borderColor = [[UIColor lightGrayColor] CGColor];
            textFieldObject.layer.borderWidth = 1.0f;
            textFieldObject.layer.cornerRadius = 5.0f;
            textFieldObject.backgroundColor = [UIColor colorWithRed:72.0f/255.0f
                                                              green:71.0f/255.0f
                                                               blue:71.0f/255.0f
                                                              alpha:1.0];
            textFieldObject.textColor = [UIColor whiteColor];
            break;
        }
    }
}

- (void)customiseCollectionView {
    self.picsCollectionView.dataSource = self;
    self.picsCollectionView.delegate = self;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    NSLog(@"sectioncount %lu", [self.fetchedResultsController.sections[0] numberOfObjects]);
    return [self.fetchedResultsController.sections[0] numberOfObjects];
}



- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    FPGridCollectionViewCell *cell
    = [collectionView dequeueReusableCellWithReuseIdentifier:PicsCollectionViewCellIdentifier
                                                forIndexPath:indexPath];
    cell.userInteractionEnabled = YES;
    [cell sizeToFit];
    [cell setImage:[UIImage imageNamed:@"PlaceHolderImage"]];
    FPPhoto *photo = self.fetchedResultsController.fetchedObjects[indexPath.row];
    
    NSString *photoURLString
    = [NSString stringWithFormat:@"https://farm%hd.staticflickr.com/%lld/%lld_%@_t.jpg",
       photo.farm, photo.serverId, photo.id, photo.secret];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.imageManager getImageForURLString:photoURLString
                                    completionBlock:^(UIImage *image) {
                                        dispatch_async(dispatch_get_main_queue(), ^{
                                            if (cell != nil) {
                                                [cell setImage:image];
                                            }
                                        });
                                    }];
        });
    });
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout*)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGSize itemSize
    = CGSizeMake(([UIScreen mainScreen].bounds.size.width - PixelWidthBetweenItems * 4) / ItemCountInOneLine,
                 ([UIScreen mainScreen].bounds.size.width - PixelWidthBetweenItems * 4) / ItemCountInOneLine);
    return itemSize;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView
                   layout:(UICollectionViewLayout *)collectionViewLayout
minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return PixelWidthBetweenItems;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView
                   layout:(UICollectionViewLayout *)collectionViewLayout
minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return PixelWidthBetweenItems;
}

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
referenceSizeForFooterInSection:(NSInteger)section {
    return CGSizeMake([UIScreen mainScreen].bounds.size.width, 44.0f);
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView
           viewForSupplementaryElementOfKind:(NSString *)kind
                                 atIndexPath:(NSIndexPath *)theIndexPath {
    FPGridCollectionFooterView *footerView;
    
    if(kind == UICollectionElementKindSectionFooter)
    {
        footerView
        = (FPGridCollectionFooterView *)[collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter
                                                                           withReuseIdentifier:PicsCollectionViewFooterViewIdentifier
                                                                                  forIndexPath:theIndexPath];
        [footerView startActivityIndicatorAnimation];
    }
    
    return footerView;
}

- (void)collectionView:(UICollectionView *)collectionView
       willDisplayCell:(UICollectionViewCell *)cell
    forItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == self.fetchedResultsController.fetchedObjects.count - 1 && !self.isLoadingNewPage) {
        NSLog(@"objectscount %lu", self.fetchedResultsController.fetchedObjects.count);
        
        self.isLoadingNewPage = YES;
        pageCount++;
        FPSearchDetail *searchDetail = [self.dataParser searchDetailFromText:searchBarText
                                                        managedObjectContext:self.managedObjectContext];
        
        NSURLQueryItem *textItem = [[NSURLQueryItem alloc] initWithName:@"text"
                                                                  value:searchBarText];
        NSURLQueryItem *pageCountItem = [[NSURLQueryItem alloc] initWithName:@"page"
                                                                       value:[NSString stringWithFormat:@"%ld", (long)pageCount]];
        NSURLQueryItem *perPageCountItem = [[NSURLQueryItem alloc] initWithName:@"per_page"
                                                                          value:[NSString stringWithFormat:@"%ld", (long)PerPagePhotosCount]];
        __weak typeof (self) weakSelf = self;
        [self.appD.sharedNetworkManager GET:SearchMethodName
                                 queryItems:@[textItem, pageCountItem, perPageCountItem]
                                    success:^(NSData *data,
                                              NSURLSessionDataTask * _Nonnull dataTask,
                                              NSDictionary * _Nullable responseObject) {
                                        NSArray *photosArray
                                        = responseObject[ResponsePhotosSupersetKey][ResponsePhotosArrayKey];
                                        for (int i = 0; i < photosArray.count; i++) {
                                            NSDictionary *photoDict = photosArray[i];
                                            [weakSelf.dataParser photoFromJSONDictionary:photoDict
                                                                      searchDetailEntity:searchDetail
                                                                    managedObjectContext:weakSelf.managedObjectContext];
                                        }
                                        
                                        NSError *saveError;
                                        [weakSelf.managedObjectContext save:&saveError];
                                        
                                        NSError *fetchError;
                                        [weakSelf.fetchedResultsController performFetch:&fetchError];
                                        
                                        dispatch_async(dispatch_get_main_queue(), ^{
                                            weakSelf.isLoadingNewPage = NO;
                                            [weakSelf.picsCollectionView reloadData];
                                        });
                                    } failure:^(NSURLSessionDataTask * _Nonnull dataTask, NSError * _Nonnull error) {
                                        
                                    }];
        
    }
    
}

- (void)collectionView:(UICollectionView *)collectionView
didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    FPPhoto *photo = self.fetchedResultsController.fetchedObjects[indexPath.row];
    NSString *photoURLString = [NSString stringWithFormat:@"https://farm%hd.staticflickr.com/%lld/%lld_%@_o.jpg",photo.farm, photo.serverId, photo.id, photo.secret];
    
    FPGridCollectionViewCell *cell
    = (FPGridCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    
    FPDetailViewController *detailVC = [[FPDetailViewController alloc] initWithPhotoThumbnail:[cell getImage]
                                                                                     photoURL:photoURLString
                                                                                 imageManager:self.imageManager
                                                                                        title:photo.title];
    [self.navigationController pushViewController:detailVC
                                         animated:YES];
}

- (NSFetchedResultsController *)fp_fetchedResultsController {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"text = %@", searchBarText];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:NSStringFromClass([FPSearchDetail class])];
    fetchRequest.predicate = predicate;
    NSError *error;
    NSArray *searchDetailArray = [self.managedObjectContext executeFetchRequest:fetchRequest
                                                                          error:&error];
    
    if (searchDetailArray.count > 0) {
        NSFetchRequest *photoFetchRequest = [[NSFetchRequest alloc] initWithEntityName:NSStringFromClass([FPPhoto class])];
        photoFetchRequest.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"date" ascending:YES]];
        NSPredicate *photoPredicate = [NSPredicate predicateWithFormat:@"ANY searchDetail = %@", searchDetailArray[0]];
        photoFetchRequest.predicate = photoPredicate;
        
        NSFetchedResultsController *fetchedResultsController
        = [[NSFetchedResultsController alloc] initWithFetchRequest:photoFetchRequest
                                              managedObjectContext:self.managedObjectContext
                                                sectionNameKeyPath:nil
                                                         cacheName:nil];
        fetchedResultsController.delegate = self;
        
        return fetchedResultsController;
    } else {
        return nil;
    }
    
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [self handleNewSearchFromSearchBar:searchBar];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [self handleNewSearchFromSearchBar:searchBar];
}

- (void)handleNewSearchFromSearchBar:(UISearchBar *)searchBar {
    if (searchBarText != nil && searchBarText != searchBar.text) {
        searchBarText = searchBar.text;
        pageCount = 1;
    } else if (searchBarText == searchBar.text){
        return;
    }
    [self.searchBar resignFirstResponder];
    searchBarText = self.searchBar.text;
    FPSearchDetail *searchDetail = [self.dataParser searchDetailFromText:searchBarText
                                                    managedObjectContext:self.managedObjectContext];
    
    self.fetchedResultsController = [self fp_fetchedResultsController];
    
    NSURLQueryItem *textItem = [[NSURLQueryItem alloc] initWithName:@"text"
                                                              value:searchBarText];
    NSURLQueryItem *pageCountItem = [[NSURLQueryItem alloc] initWithName:@"page"
                                                                   value:[NSString stringWithFormat:@"%ld", (long)pageCount]];
    NSURLQueryItem *perPageCountItem = [[NSURLQueryItem alloc] initWithName:@"per_page"
                                                                      value:[NSString stringWithFormat:@"%ld", (long)PerPagePhotosCount]];
    
    __weak typeof (self) weakSelf = self;
    [self.appD.sharedNetworkManager GET:SearchMethodName
                             queryItems:@[textItem, pageCountItem, perPageCountItem]
                                success:^(NSData *data,
                                          NSURLSessionDataTask * _Nonnull dataTask,
                                          NSDictionary * _Nullable responseObject) {
                                    NSArray *photosArray = responseObject[ResponsePhotosSupersetKey][ResponsePhotosArrayKey];
                                    for (int i = 0; i < photosArray.count; i++) {
                                        NSDictionary *photoDict = photosArray[i];
                                        [weakSelf.dataParser photoFromJSONDictionary:photoDict
                                                                  searchDetailEntity:searchDetail
                                                                managedObjectContext:weakSelf.managedObjectContext];
                                    }
                                    
                                    NSError *saveError;
                                    [weakSelf.managedObjectContext save:&saveError];
                                    
                                    NSError *fetchError;
                                    [weakSelf.fetchedResultsController performFetch:&fetchError];
                                    
                                    dispatch_async(dispatch_get_main_queue(), ^{
                                        [self.picsCollectionView reloadData];
                                    });
                                    
                                } failure:^(NSURLSessionDataTask * _Nonnull dataTask, NSError * _Nonnull error) {
                                    NSLog(@"Error %@", error.description);
                                }];
}

@end
