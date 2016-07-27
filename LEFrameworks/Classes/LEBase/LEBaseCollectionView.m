//
//  LEBaseCollectionView.m
//  LEFrameworks
//
//  Created by emerson larry on 16/7/21.
//  Copyright © 2016年 LarryEmerson. All rights reserved.
//

#import "LEBaseCollectionView.h" 

@interface LECollectionViewSettings ()
@property (nonatomic, readwrite) LEAutoLayoutSettings *leSettings;
@property (nonatomic, readwrite) UICollectionViewLayout *leLayout;
@property (nonatomic, readwrite) NSString *leCellClassname;
@property (nonatomic, readwrite) NSString *leReusableViewClassname;
@property (nonatomic, readwrite) id<LECollectionViewDataSourceDelegate> leDataSourceDelegate;
@property (nonatomic, readwrite) id<LECollectionViewCellSelectionDelegate> leCellSelectionDelegate;
@end
@implementation LECollectionViewSettings
-(instancetype) initWithAutoLayoutSettings:(LEAutoLayoutSettings *) settings CollectionLayout:(UICollectionViewLayout *) layout CellClassname:(NSString *) cellClassname DataSource:(id<LECollectionViewDataSourceDelegate>) dataSource CellSelectionDelegate:(id<LECollectionViewCellSelectionDelegate>) selection{
    self=[super init];
    self.leSettings=settings;
    self.leLayout=layout;
    self.leCellClassname=cellClassname;
    self.leDataSourceDelegate=dataSource;
    self.leCellSelectionDelegate=selection;
    return self;
}
-(instancetype) initWithAutoLayoutSettings:(LEAutoLayoutSettings *) settings CollectionLayout:(UICollectionViewLayout *) layout CellClassname:(NSString *) cellClassname ReusableView:(NSString *) reusableClassname DataSource:(id<LECollectionViewDataSourceDelegate>) dataSource CellSelectionDelegate:(id<LECollectionViewCellSelectionDelegate>) selection{
    self=[self initWithAutoLayoutSettings:settings CollectionLayout:layout CellClassname:cellClassname DataSource:dataSource CellSelectionDelegate:selection];
    self.leReusableViewClassname=reusableClassname;
    return self;
}
@end
//Cell
@interface LEBaseCollectionViewCell ()
@property (nonatomic, readwrite) NSIndexPath *leIndexPath;
@end
@implementation LEBaseCollectionViewCell
-(void) leSetData:(id) data IndexPath:(NSIndexPath *) path{
    self.leIndexPath=path;
}
@end
//ReusableView
@interface LEBaseCollectionReusableView ()
@property (nonatomic, readwrite) NSIndexPath *leIndexPath;
@end
@implementation LEBaseCollectionReusableView
-(void) leSetData:(id) data Kind:(NSString *) kind IndexPath:(NSIndexPath *) path{
    self.leIndexPath=path;
}
@end
//View
@interface LEBaseCollectionView ()
@property (nonatomic, readwrite) NSMutableArray *leItemsArray; 
@property (nonatomic, readwrite) id<LECollectionViewDataSourceDelegate> leDataSourceDelegate;
@property (nonatomic, readwrite) id<LECollectionViewCellSelectionDelegate> leCellSelectionDelegate;
@end
@implementation LEBaseCollectionView{
    BOOL autoDeselect;
    NSString *curCellClassname;
}
-(void) leAutoDeselectCellAfterSelection:(BOOL) enable{
    autoDeselect=enable;
}
//
-(void) leSetTopRefresh:(BOOL) enable{
    
}
-(void) leSetBottomRefresh:(BOOL) enable{
    
}
//
-(void) leOnStopTopRefresh {
    [self reloadData];
}
-(void) leOnStopBottomRefresh {
    [self reloadData];
}
//
-(void) onDelegateRefreshData{
    //    LELogFunc
    if(self.leDataSourceDelegate){
        if([self.leDataSourceDelegate respondsToSelector:@selector(leOnRefreshDataForCollection)]){
            [self.leDataSourceDelegate leOnRefreshDataForCollection];
        }
    }
}
-(void) onDelegateLoadMore{
    //    LELogFunc
    if(self.leDataSourceDelegate){
        if([self.leDataSourceDelegate respondsToSelector: @selector(leOnLoadMoreForCollection)]){
            [self.leDataSourceDelegate leOnLoadMoreForCollection];
        }
    }
}
//
-(void) leOnAutoRefresh{
}
-(void) leOnAutoRefreshWithDuration:(float) duration{
    [NSTimer scheduledTimerWithTimeInterval:duration target:self selector:@selector(leOnAutoRefresh) userInfo:nil repeats:NO];
}
//
-(void) leOnRefreshedWithData:(NSMutableArray *)data{
    if(data){
        self.leItemsArray=[data mutableCopy];
    }
    [self leOnStopTopRefresh];
}
-(void) leOnLoadedMoreWithData:(NSMutableArray *)data{
    if(data){
        NSInteger section=[self leNumberOfSectionsInCollectionView:self];
        if(section>1){
            [self leOnStopBottomRefresh];
            return;
        }
        if(!self.leItemsArray){
            self.leItemsArray=[[NSMutableArray alloc] init];
        }
        [self.leItemsArray addObjectsFromArray:data];
    }
    [self leOnStopBottomRefresh];
}
-(void) leDeselectCellAtIndex:(NSIndexPath *) index{
    [self deselectItemAtIndexPath:index animated:YES];
}
//==========
-(instancetype) initWithSettings:(LECollectionViewSettings *) settings{
    CGRect rect=[UIView leGetFrameWithAutoLayoutSettings:settings.leSettings];
    self=[super initWithFrame:rect collectionViewLayout:settings.leLayout];
    [settings.leSettings.leSuperView addSubview:self];
    self.leAutoLayoutSettings=settings.leSettings;
    self.leDataSourceDelegate=settings.leDataSourceDelegate;
    self.leCellSelectionDelegate=settings.leCellSelectionDelegate;
    [self setAllowsSelection:YES];
    [self setDelegate:self];
    [self setDataSource:self];
    [self registerClass:NSClassFromString(settings.leCellClassname) forCellWithReuseIdentifier:LEReuseableCollectionCellIdentifier];
    if(settings.leReusableViewClassname&&settings.leReusableViewClassname.length>0){
        [self registerClass:NSClassFromString(settings.leReusableViewClassname) forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:LEReuseableCollectionViewIdentifier];
        [self registerClass:NSClassFromString(settings.leReusableViewClassname) forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:LEReuseableCollectionViewIdentifier];
    }
    [self setBackgroundColor:LEColorClear];
    [self leExtraInits];
    [self setAlwaysBounceVertical:YES];
    autoDeselect=YES;
    return self;
}
//Sections
- (NSInteger)leNumberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    NSInteger section=0;
    if(self.leItemsArray.count>0){
        id obj=[self.leItemsArray objectAtIndex:0];
        if([obj isKindOfClass:[NSArray class]]||[obj isMemberOfClass:[NSArray class]]){
            section=self.leItemsArray.count;
        }else{
            section=1;
        }
    }
    if(self.leSectionHeaderArray.count>0){
        section=MAX(section, self.leSectionHeaderArray.count);
    }
    return section;
}
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return [self leNumberOfSectionsInCollectionView:collectionView];
}
//numbers
- (NSInteger)leCollectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    NSInteger items=0;
    if(self.leItemsArray&&self.leItemsArray.count>0){
        NSInteger sections=[self leNumberOfSectionsInCollectionView:collectionView];
        if(sections==1){
            items= self.leItemsArray.count;
        }else if(sections>1){
            if(section<self.leItemsArray.count){
                id obj=[self.leItemsArray objectAtIndex:section];
                if(obj&&([obj isKindOfClass:[NSArray class]]||[obj isMemberOfClass:[NSArray class]])){
                    items= [obj count];
                }
            }
        }
    }
    return items;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return [self leCollectionView:collectionView numberOfItemsInSection:section];
}
//Cell
- (UICollectionViewCell *)leCollectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    LEBaseCollectionViewCell *cell=[self dequeueReusableCellWithReuseIdentifier:LEReuseableCollectionCellIdentifier forIndexPath:indexPath];
    if(!cell.isInited){
        cell.isInited=YES;
        [cell leExtraInits];
    }
    BOOL hasSet=NO;
    if(self.leItemsArray&&self.self.leItemsArray.count>0){
        NSInteger section=[self leNumberOfSectionsInCollectionView:collectionView];
        if(section==1){
            [cell leSetData:indexPath.row<self.leItemsArray.count?[self.leItemsArray objectAtIndex:indexPath.row]:nil IndexPath:indexPath];
            hasSet=YES;
        }else if(section>1){
            if(indexPath.section<self.leItemsArray.count){
                id obj=[self.leItemsArray objectAtIndex:indexPath.section];
                if(obj&&([obj isKindOfClass:[NSArray class]]||[obj isMemberOfClass:[NSArray class]])){
                    if(indexPath.row<[obj count]){
                        [cell leSetData:[obj objectAtIndex:indexPath.row] IndexPath:indexPath];
                        hasSet=YES;
                    }
                }
            }
        }
    }
    if(!hasSet){
        [cell leSetData:nil IndexPath:indexPath];
    }
    return cell;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    return [self leCollectionView:collectionView cellForItemAtIndexPath:indexPath];
}
//
- (void)leCollectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if(self.leCellSelectionDelegate&&[self.leCellSelectionDelegate respondsToSelector:@selector(leOnCollectionCellSelectedWithInfo:)]){
        [self.leCellSelectionDelegate leOnCollectionCellSelectedWithInfo:@{LEKeyOfIndexPath:indexPath}];
    }
    if(autoDeselect){
        [self leDeselectCellAtIndex:indexPath];
    }
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [self leCollectionView:collectionView didSelectItemAtIndexPath:indexPath];
}
//
- (UICollectionReusableView *)leCollectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    LEBaseCollectionReusableView *view=[self dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:LEReuseableCollectionViewIdentifier forIndexPath:indexPath];
    if(!view.isInited){
        view.isInited=YES;
        [view leExtraInits];
    }
    [view leSetData:self.leSectionHeaderArray&&indexPath.section<self.leSectionHeaderArray.count?[self.leSectionHeaderArray objectAtIndex:indexPath.section]:nil Kind:kind IndexPath:indexPath]; 
    return view;
}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    return [self leCollectionView:collectionView viewForSupplementaryElementOfKind:kind atIndexPath:indexPath];
}
@end

