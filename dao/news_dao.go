/*
 * Copyright (c) 2020.
 * MbungeApp Inc all rights reserved
 */

package dao

import (
	"context"
	"fmt"
	"go.mongodb.org/mongo-driver/bson"
	"go.mongodb.org/mongo-driver/bson/primitive"
	"go.mongodb.org/mongo-driver/mongo"
	"mbunge-admin/models/db"
	"time"
)

type NewsDaoInterface interface {
	TotalNews() int
	ReadAllNews() ([]db.EventNew, error)
	ReadOneNews(newsID string) db.EventNew
	CreateNews(news db.EventNew) error
	UpdateNews(newsID string, key string, value string) error
	DeleteNews(newsID string) error
}

type NewNewsDaoInterface struct {
	Client *mongo.Client
}

func newsCollection(client *mongo.Client) *mongo.Collection {
	return client.Database("mbunge").Collection("event")
}
func (n NewNewsDaoInterface) TotalNews() int {
	var events []db.EventNew

	cursor, err := newsCollection(n.Client).Find(context.Background(), bson.M{})
	if err != nil {
		return 0
	}
	err = cursor.All(context.Background(), &events)
	if err != nil {
		return 0
	}
	return len(events)
}
func (n NewNewsDaoInterface) ReadAllNews() ([]db.EventNew, error) {
	var events []db.EventNew

	cursor, err := newsCollection(n.Client).Find(context.Background(), bson.M{})
	if err != nil {
		return nil, err
	}
	err = cursor.All(context.Background(), &events)
	if err != nil {
		return nil, err
	}
	return events, nil
}
func (n NewNewsDaoInterface) ReadOneNews(newsID string) db.EventNew {
	objectID, _ := primitive.ObjectIDFromHex(newsID)
	var news db.EventNew

	err := newsCollection(n.Client).FindOne(context.Background(), bson.D{{"_id", objectID}}).Decode(&news)
	if err != nil {
		//log.Fatal(err)
		if err == mongo.ErrNoDocuments {
			return db.EventNew{}
		}
	}
	return news
}
func (n NewNewsDaoInterface) CreateNews(news db.EventNew) error {
	news.UpdatedAt = time.Now()
	news.CreatedAt = time.Now()
	news.ID = primitive.NewObjectID()
	_, err := newsCollection(n.Client).InsertOne(context.Background(), news)
	if err != nil {
		return err
	}
	return nil
}
func (n NewNewsDaoInterface) UpdateNews(newsID string, key string, value string) error {
	objID, _ := primitive.ObjectIDFromHex(newsID)
	filter := bson.D{{"_id", objID}}
	update := bson.D{{Key: "$set", Value: bson.M{key: value, "updated_at": time.Now()}}}

	result, err := newsCollection(n.Client).UpdateOne(
		context.Background(),
		filter,
		update,
	)
	if err != nil {
		fmt.Println(err)
		return err
	}
	if result.MatchedCount != 0 {
		fmt.Println("matched and replaced an existing document")
		return nil
	}
	if result.UpsertedCount != 0 {
		fmt.Printf("inserted a new document with ID %v\n", result.UpsertedID)
	}
	return nil
}
func (n NewNewsDaoInterface) DeleteNews(newsID string) error {
	objectID, _ := primitive.ObjectIDFromHex(newsID)
	_, err := newsCollection(n.Client).DeleteOne(context.Background(), bson.M{
		"_id": objectID,
	})
	if err != nil {
		return err
	}
	return nil
}
