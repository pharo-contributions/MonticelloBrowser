"
SearchFacade is a facade for creating searching dialog window
"
Class {
	#name : #MCSearchFacade,
	#superclass : #Object,
	#category : #'MonticelloGUI-Tools'
}

{ #category : #'message search' }
MCSearchFacade class >> allMessageSearchFor: aClass [

	^ self messageSearchIn: aClass allMethods
]

{ #category : #'class search' }
MCSearchFacade class >> classSearch [

	^ self classSearchInEnvironment: self environment
]

{ #category : #'class search' }
MCSearchFacade class >> classSearchIn: classes [
	^ ListDialogWindow new
		getList: [ :r | classes select: [ :e | r search: e name ] ];
		displayBlock: [ :e | e name ];
		title: 'Class search' translated;
		yourself
]

{ #category : #'class search' }
MCSearchFacade class >> classSearchInEnvironment: anEnvironment [
	| classes |
	classes :=  anEnvironment classesAndTraits sorted: [ :a :b| a name <= b name ].
	^ self classSearchIn: classes.
]

{ #category : #'class search' }
MCSearchFacade class >> hierarchySearchFor: aClass [
	| classes |
	classes := aClass allSuperclasses reverse, (aClass allSubclasses sorted: [ :a :b| a name <= b name ]).
	^ self classSearchIn: classes
]

{ #category : #'package search' }
MCSearchFacade class >> mcPackageSearch [
	^ self mcPackageSearchRejectAll: [ :aPackage | false ] withInitialFilter: nil
]

{ #category : #'package search' }
MCSearchFacade class >> mcPackageSearchRejectAll: aRejectBlock [
	^ self mcPackageSearchRejectAll: aRejectBlock withInitialFilter: nil
]

{ #category : #'package search' }
MCSearchFacade class >> mcPackageSearchRejectAll: aRejectBlock withInitialFilter: filter [
	| workingCopies |
	
	workingCopies := MCWorkingCopy allManagers asSortedCollection: [ :a :b | a packageName <= b packageName].
	workingCopies := workingCopies reject: aRejectBlock.
	
	^ ListDialogWindow new
				getList: [ :regex | workingCopies select: [ :workingCopy | regex search: workingCopy package name] ];
				displayBlock: [ :workingCopy | workingCopy package name ];
				title: 'Monticello packages';
				initialFilter: (filter ifNil: [ '' ] ifNotNil: [ filter]);
				yourself. 

]

{ #category : #'message search' }
MCSearchFacade class >> messageSearchFor: aClass [

	^ self messageSearchIn: aClass methods
]

{ #category : #'message search' }
MCSearchFacade class >> messageSearchIn: aCollection [
	| rawList |
	rawList := aCollection sorted: [ :a :b | a selector <= b selector ].
	^ ListDialogWindow new
		getList: [ :r | rawList select: [ :e | r search: e selector ] ];
		displayBlock: [ :e | e selector ];
		title: 'Message search' translated;
		yourself
]

{ #category : #'package search' }
MCSearchFacade class >> packageSearch [
				
	^ self packageSearchIn: self environment
]

{ #category : #'package search' }
MCSearchFacade class >> packageSearchIn: anEnvironment [
	| rawList |
	rawList := anEnvironment organization categories sort.
	^ ListDialogWindow new
		getList: [ :r | rawList select: [ :e | r search: e ] ];
		displayBlock: [ :e | e ];
		title: 'Package search' translated;
		yourself
]

{ #category : #'protocol search' }
MCSearchFacade class >> protocolSearchIn: aCollection [
	^ ListDialogWindow new
		getList: [ :r | aCollection sorted select: [ :e | r search: e ] ];
		displayBlock: [ :e | e ];
		title: 'Protocol search' translated;
		yourself
]

{ #category : #'rpackage search' }
MCSearchFacade class >> rPackageSearch [
				
	^ self rPackageSearchIn: RPackageOrganizer default
]

{ #category : #'rpackage search' }
MCSearchFacade class >> rPackageSearchIn: anOrganizer [
	| rawList |
	rawList := anOrganizer packages sorted: [ :a :b | a name <= b name ].
	^ ListDialogWindow new
		getList: [ :r | rawList select: [ :e | r search: e name ] ];
		displayBlock: [ :e | e name ];
		browseBlock: [ :answer | Smalltalk tools browser openOnPackage: answer ];
		title: 'Package search' translated;
		yourself
]

{ #category : #'class search' }
MCSearchFacade class >> subclassSearchFor: aClass [
	| classes |
	classes := aClass allSubclasses sorted: [ :a :b| a name <= b name ].
	^ self classSearchIn: classes
]

{ #category : #'class search' }
MCSearchFacade class >> superclassSearchFor: aClass [

	^ self classSearchIn: aClass allSuperclasses reverse
]
