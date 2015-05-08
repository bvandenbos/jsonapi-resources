require File.expand_path('../../../test_helper', __FILE__)
require 'jsonapi-resources'

class SerializerIncludeDirectivesTest < ActiveSupport::TestCase

  def test_one_level_one_include
    directives = JSONAPI::SerializerIncludeDirectives.new(['posts']).include_directives

    assert_hash_equals(
      {
        include_related: {
          posts: {
            include: true,
            include_related:{}
          }
        }
      },
      directives)
  end

  def test_one_level_multiple_includes
    directives = JSONAPI::SerializerIncludeDirectives.new(['posts', 'comments', 'tags']).include_directives

    assert_hash_equals(
      {
        include_related: {
          posts: {
            include: true,
            include_related:{}
          },
          comments: {
            include: true,
            include_related:{}
          },
          tags: {
            include: true,
            include_related:{}
          }
        }
      },
      directives)
  end

  def test_two_levels_include_full
    directives = JSONAPI::SerializerIncludeDirectives.new(['posts', 'posts.comments']).include_directives

    assert_hash_equals(
      {
        include_related: {
          posts: {
            include: true,
            include_related:{
              comments: {
                include: true,
                include_related:{}
              }
            }
          }
        }
      },
      directives)
  end

  def test_two_levels_include_lowest_only
    directives = JSONAPI::SerializerIncludeDirectives.new(['posts.comments']).include_directives

    assert_hash_equals(
      {
        include_related: {
          posts: {
            include: false,
            include_related:{
              comments: {
                include: true,
                include_related:{}
              }
            }
          }
        }
      },
      directives)
  end

  def test_three_levels_include_full
    directives = JSONAPI::SerializerIncludeDirectives.new(['posts', 'posts.comments', 'posts.comments.tags']).include_directives

    assert_hash_equals(
      {
        include_related: {
          posts: {
            include: true,
            include_related:{
              comments: {
                include: true,
                include_related:{
                  tags: {
                    include: true,
                    include_related:{}
                  }
                }
              }
            }
          }
        }
      },
      directives)
  end

  def test_three_levels_skip_middle
    directives = JSONAPI::SerializerIncludeDirectives.new(['posts', 'tags', 'posts.comments.tags']).include_directives

    assert_hash_equals(
      {
        include_related: {
          tags: {
            include: true,
            include_related:{}
          },
          posts: {
            include: true,
            include_related:{
              comments: {
                include: false,
                include_related:{
                  tags: {
                    include: true,
                    include_related:{}
                  }
                }
              }
            }
          }
        }
      },
      directives)
  end
end
