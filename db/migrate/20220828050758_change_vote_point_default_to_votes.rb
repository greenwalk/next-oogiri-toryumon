class ChangeVotePointDefaultToVotes < ActiveRecord::Migration[6.0]
  def change
    change_column_default :votes, :vote_point, nil
  end
end
