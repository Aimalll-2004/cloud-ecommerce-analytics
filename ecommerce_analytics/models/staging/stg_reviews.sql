with source as (
    select * from {{ source('raw', 'reviews') }}
)

select

    review_id,
    order_id,
    try_cast(review_score as integer) as review_score,
    review_comment_title,
    review_comment_message,
    try_to_timestamp_ntz(review_creation_date) as review_creation_date,
    try_to_timestamp_ntz(review_answer_timestamp) as review_answer_timestamp

from source