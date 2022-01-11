map(obstacle).
+obstacle(Direction)
	:	position(X,Y) 
		& locationName(Current, [X,Y]) 
		& possible(Current,Next)
		& direction(Current,Next,Direction)
		& mission(Goal,Parameters)
	<-	-possible(Current,Next);
		.drop_all_intentions;
		!mission(Goal,Parameters).