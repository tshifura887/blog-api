class CommentsController < ApplicationController
    before_action :set_article
    before_action :set_comment, only: [:show, :update, :destroy]

    def index 
        json_response(@article.comments)
    end

    def show
        json_response(@comment)
    end

    def create  
        @article.comments.create!(comment_params)
        json_response(@comment, :created)
    end

    def update 
        @comment.update(comment_params)
        head :no_content
    end

    def destroy 
        @comment.destroy
        head :no_content
    end

    private 
    def set_article 
        @article = Article.find(params[:article_id])
    end

    def set_comment 
        @comment = @article.comments.find(params[:id])
    end

    def comment_params 
        params.permit(:commenter, :comment)
    end
end
