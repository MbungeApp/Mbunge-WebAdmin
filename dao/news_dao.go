/*
 * Copyright (c) 2020.
 * MbungeApp Inc all rights reserved
 */

package dao

import (
	"context"
	"go.mongodb.org/mongo-driver/bson"
	"go.mongodb.org/mongo-driver/bson/primitive"
	"go.mongodb.org/mongo-driver/mongo"
	"mbunge-admin/models/db"
	"time"
)

// CRUD
type NewsDaoInterface interface {
	ReadAllNews() []db.EventNew
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
func (u NewNewsDaoInterface) ReadNews() ([]db.EventNew, error) {
	var events []db.EventNew

	cursor, err := newsCollection(u.Client).Find(context.Background(), bson.M{})
	if err != nil {
		return nil, err
	}
	err = cursor.All(context.Background(), &events)
	if err != nil {
		return nil, err
	}
	return events, nil
}

func (u NewNewsDaoInterface) ReadOneNews(newsID string) db.EventNew {
	objectID, _ := primitive.ObjectIDFromHex(newsID)
	var news db.EventNew

	err := newsCollection(u.Client).FindOne(context.Background(), bson.M{
		"_id": objectID,
	}).Decode(news)
	if err != nil {
		//log.Fatal(err)
		if err == mongo.ErrNoDocuments {
			return db.EventNew{}
		}
	}
	return news
}
func (u NewNewsDaoInterface) CreateNews(news db.EventNew) error {
	news.UpdatedAt = time.Now()
	news.CreatedAt = time.Now()
	_, err := newsCollection(u.Client).InsertOne(context.Background(), news)
	if err != nil {
		return err
	}
	return nil
}
func (u NewNewsDaoInterface) UpdateNews(newsID string, key string, value string) error {
	objID, _ := primitive.ObjectIDFromHex(newsID)
	filter := bson.D{{"_id", objID}}
	update := bson.D{{Key: "$set", Value: bson.M{key: value, "updated_at": time.Now()}}}

	_, err := newsCollection(u.Client).UpdateOne(
		context.Background(),
		filter,
		update,
	)
	if err != nil {
		return err
	}
	return nil
}
func (u NewNewsDaoInterface) DeleteNews(newsID string) error {
	objectID, _ := primitive.ObjectIDFromHex(newsID)
	_, err := newsCollection(u.Client).DeleteOne(context.Background(), bson.M{
		"_id": objectID,
	})
	if err != nil {
		return err
	}
	return nil
}
