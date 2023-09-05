require "rails_helper"

RSpec.describe RateLimitValidator do
  describe "#validate" do
    let(:creator) { create(:user) }

    context "with time_frame" do
      before do
        Post.clear_validators!
        Post.validates_with RateLimitValidator,
                            limit: 10,
                            scope: :creator_id,
                            time_frame: 1.day
      end

      after { Post.clear_validators! }

      it "does not add any error if the rate limit is not exceeded" do
        create_list(:post, 9, creator: creator)
        post = build(:post, creator: creator)
        post.validate
        expect(post.errors).to be_empty
      end

      it "adds an error if the rate limit is exceeded" do
        create_list(:post, 10, creator: creator)
        post = build(:post, creator: creator)
        post.validate
        expect(post.errors[:base]).to include("Rate limit exceeded: 10")
      end
    end

    context "without time_frame" do
      before do
        Post.clear_validators!
        Post.validates_with RateLimitValidator, limit: 10, scope: :creator_id
      end

      after { Post.clear_validators! }

      it "does not add any error if the rate limit is not exceeded" do
        create_list(:post, 9, creator: creator)
        post = build(:post, creator: creator)
        post.validate
        expect(post.errors).to be_empty
      end

      it "adds an error if the rate limit is exceeded" do
        create_list(:post, 10, creator: creator)
        post = build(:post, creator: creator)
        post.validate
        expect(post.errors[:base]).to include("Rate limit exceeded: 10")
      end
    end
  end
end