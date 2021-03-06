//
//  AlbumsViewControllerDelegate.swift
//  Locations
//
//  Created by Bill A on 2/4/19.
//  Copyright © 2019 District-1. All rights reserved.
//

import UIKit

class AlbumsViewDelegateProvider: DelegateSelectionProvideable {
    
    static private var transitioningCoordinator: UIViewControllerTransitioningDelegate?

    public typealias ViewController = SequenceFetching
    public var viewController: ViewController!
    
    var selectionProvider: DelegateSelectionProvideable? { return self }
    var highlightProvider: DelegateHighlightProvideable? { return self }

    /// Initialzer for the Albums Datasource.
    ///
    /// - Parameters:
    ///    - fetchedController: Injects the dependency on the FetchedCollectionViewController into the Datasource class.
    public init<ViewController: SequenceFetching>(withViewController viewController: ViewController) {
        self.viewController = viewController
    }
 
    func didSelect(itemAt indexPath: IndexPath) {
        guard let sequenceView = viewController.sequenceView,
            let albums = viewController.fetchedResultsController?.fetchedObjects
            else {
                Log.message("Albums Datasource Undefined")
                return
        }
        let selectedAlbum = albums[indexPath.row]
        let detailViewController = AlbumDetailViewController(objectID: selectedAlbum.objectID)
        let destinationViewController = UINavigationController(rootViewController: detailViewController)
        AlbumsViewDelegateProvider.transitioningCoordinator = ViewControllerTransitioningCoordinator(with: sequenceView, for: indexPath)
        destinationViewController.transitioningDelegate = AlbumsViewDelegateProvider.transitioningCoordinator
        destinationViewController.modalPresentationStyle = .custom
        viewController.navigationController?.present(destinationViewController, animated: true)
    }
    
}

extension AlbumsViewDelegateProvider: DelegateHighlightProvideable {
    func shouldHighlight(itemAt indexPath: IndexPath) -> Bool {
        return true
    }
}
