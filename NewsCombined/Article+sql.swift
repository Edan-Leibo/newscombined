//
//  Article+sql.swift
//  NewsCombined
//
//  Created by admin on 21/02/2018.
//  Copyright © 2018 London App Brewery. All rights reserved.
//

import Foundation

/*
 var id : String = ""
 var url : String = ""
 var title : String = ""
 var imageURL : String = ""
 var description : String = ""
 var author : String = ""
 var source : String = ""
 var clusterKey : String = ""    //foreign KEYS
 var content : String = ""
 var lastUpdate:Date?

 */


extension Article{
    static let ART_TABLE = "ARTICLES"
    static let ART_ID = "ART_ID"
    static let ART_URL = "ART_URL"
    static let ART_TITLE = "ART_TITLE"
    static let ART_IMAGE_URL = "ART_IMAGE_URL"
    static let ART_DESC = "ART_DESC"
    static let ART_AUTH = "ART_AUTH"
    static let ART_SOURCE = "ART_SOURCE"
    static let ART_CLUSTERKEY = "ART_CLUSTERKEY"
    static let ART_CONTENT = "ART_CONTENT"
    static let ART_LAST_UPDATE = "ART_LAST_UPDATE"
 
    
    
    static func createTable(database:OpaquePointer?)->Bool{
        var errormsg: UnsafeMutablePointer<Int8>? = nil
        
        let res = sqlite3_exec(database, "CREATE TABLE IF NOT EXISTS " + ART_TABLE + " ( " + ART_ID + " TEXT PRIMARY KEY, "
            + ART_URL + " TEXT, "
            + ART_TITLE + " TEXT, "
            + ART_IMAGE_URL + " TEXT, "
            + ART_DESC + " TEXT, "
            + ART_AUTH + " TEXT, "
            + ART_SOURCE + " TEXT, "
             + ART_CLUSTERKEY + " TEXT, "
             + ART_CONTENT + " TEXT, "
            + ART_LAST_UPDATE + " DOUBLE)", nil, nil, &errormsg);
        if(res != 0){
            print("error creating table");
            return false
        }
        
        return true
    }
    
    func addArticleToLocalDb(database:OpaquePointer?){
        var sqlite3_stmt: OpaquePointer? = nil
        if (sqlite3_prepare_v2(database,"INSERT OR REPLACE INTO " + Article.ART_TABLE
            + "(" + Article.ART_ID + ","
            + Article.ART_URL + ","
            + Article.ART_TITLE + ","
            + Article.ART_IMAGE_URL + ","
            + Article.ART_DESC + ","
            + Article.ART_AUTH + ","
            + Article.ART_SOURCE + ","
            + Article.ART_CLUSTERKEY + ","
            + Article.ART_CONTENT + ","
            + Article.ART_LAST_UPDATE + ") VALUES (?,?,?,?,?,?,?,?,?,?);",-1, &sqlite3_stmt,nil) == SQLITE_OK){
            
            
            let id = self.id.cString(using: .utf8)
            let url = self.url.cString(using: .utf8)
            let title = self.title.cString(using: .utf8)
            let imageURL = self.imageURL.cString(using: .utf8)

            let description = self.description.cString(using: .utf8)
            let author = self.author.cString(using: .utf8)
            let source = self.source.cString(using: .utf8)
            let clusterKey = self.clusterKey.cString(using: .utf8)
            let content = self.content.cString(using: .utf8)
         
            sqlite3_bind_text(sqlite3_stmt, 1, id,-1,nil);
            sqlite3_bind_text(sqlite3_stmt, 2, url,-1,nil);
            sqlite3_bind_text(sqlite3_stmt, 3, title,-1,nil);
            sqlite3_bind_text(sqlite3_stmt, 4, imageURL,-1,nil);
            sqlite3_bind_text(sqlite3_stmt, 5, description,-1,nil);
            sqlite3_bind_text(sqlite3_stmt, 6, author,-1,nil);
            sqlite3_bind_text(sqlite3_stmt, 7, source,-1,nil);
            sqlite3_bind_text(sqlite3_stmt, 8, clusterKey,-1,nil);
            sqlite3_bind_text(sqlite3_stmt, 9, content,-1,nil);

            if (lastUpdate == nil){
                lastUpdate = Date()
            }
            sqlite3_bind_double(sqlite3_stmt, 10, lastUpdate!.toFirebase());
            
            if(sqlite3_step(sqlite3_stmt) == SQLITE_DONE){
                //print("new row added succefully")
            }
        }
        sqlite3_finalize(sqlite3_stmt)
    }
    
    static func getAllArticlesFromLocalDb(database:OpaquePointer?)->[Article]{
        var articles = [Article]()
        var sqlite3_stmt: OpaquePointer? = nil
        if (sqlite3_prepare_v2(database,"SELECT * from "+ART_TABLE+";",-1,&sqlite3_stmt,nil) == SQLITE_OK){
            while(sqlite3_step(sqlite3_stmt) == SQLITE_ROW){
                let id =  String(validatingUTF8:sqlite3_column_text(sqlite3_stmt,0))
                let url =  String(validatingUTF8:sqlite3_column_text(sqlite3_stmt,1))
                let title =  String(validatingUTF8:sqlite3_column_text(sqlite3_stmt,2))
                var imageURL =  String(validatingUTF8:sqlite3_column_text(sqlite3_stmt,3))
                let description =  String(validatingUTF8:sqlite3_column_text(sqlite3_stmt,4))
                let author =  String(validatingUTF8:sqlite3_column_text(sqlite3_stmt,5))
                let source =  String(validatingUTF8:sqlite3_column_text(sqlite3_stmt,6))
                let clusterKey =  String(validatingUTF8:sqlite3_column_text(sqlite3_stmt,7))
                let content =  String(validatingUTF8:sqlite3_column_text(sqlite3_stmt,8))

                
                
                //let update =  Double(sqlite3_column_double(sqlite3_stmt,3))
                if (imageURL != nil && imageURL == ""){
                    imageURL = nil
                }
                let article = Article(insertId : id!, inserturl : url!, inserttitle : title!,insertimageURL : imageURL!, insertdescription : description!, insertauthor : author!, insertsource : source! , insertcontent : content!, insertclusterkey : clusterKey!)
                articles.append(article)
            }
        }
        sqlite3_finalize(sqlite3_stmt)
        return articles
    }
    
}