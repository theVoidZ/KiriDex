using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class PlayerMovement : MonoBehaviour
{


    public float speed = 4;
    public float jumpVelocity = 6;

    
    private Rigidbody2D rigidbody2D;
    private Animator animator;
    
    
    public float fallMutiplier = 2.5f;
    public float lowJumpMultiplier = 2f;
        
    
    public bool onGround = true;
    public bool isJumping = false;
    public int isJumpingx2 = 2;
    public bool isJumpingFall = false;
    
    private float moveDirection;
    private bool isFacingRight = true;

    public float checkRadius = 0.5f;
    public Transform groundCheck;
    public LayerMask WhatIsGround;
    
    void Awake()
    {
        rigidbody2D = GetComponent<Rigidbody2D>();
        animator = GetComponent<Animator>();
        animator.speed = 1.75f;
    }
    
    
    
    void Update()
    {
        moveDirection = 0;
        
        moveDirection = Input.GetAxisRaw("Horizontal");
        
        if (Input.GetKeyDown(KeyCode.Space) )
        {
            if( isJumpingx2 > 0 )
                Jump();
        }

    }
    
    void FixedUpdate()
    {

        onGround = Physics2D.OverlapCircle(groundCheck.position, checkRadius, WhatIsGround );
        animator.SetBool("onGround", onGround);

        
        // H-Key pressed
        if (moveDirection != 0)
        {
            animator.SetBool("isMoving", true);

            FlipAnimation( moveDirection );
            rigidbody2D.velocity = new Vector2( moveDirection * Time.deltaTime * speed , rigidbody2D.velocity.y);                
            
        }
        else
        {
            animator.SetBool("isMoving", false);

            // fadeout if key unpressed and on the ground?
            if ( Mathf.Abs(rigidbody2D.velocity.x) > float.Epsilon)
            {
                rigidbody2D.velocity = new Vector2(Mathf.SmoothStep(rigidbody2D.velocity.x, 0f, Mathf.Abs(rigidbody2D.velocity.x) * 0.75f), rigidbody2D.velocity.y );
            }

        }
        // better Jump code
        // falling
        if (rigidbody2D.velocity.y <= 0)
        {
            // if has jumped
            if (isJumping)
            {
                animator.SetBool("isJumpFalling", true);
                isJumping = false;
                isJumpingFall = true;
            }
            else
            {
                isJumpingFall = true;
                animator.SetBool("isJumpFalling", true);
            }

            rigidbody2D.velocity += Vector2.up * (Physics2D.gravity.y * (fallMutiplier - 1) * Time.deltaTime);

        }else if (rigidbody2D.velocity.y > 0 )
        {
            if (isJumping)
            {
            }
            rigidbody2D.velocity += Vector2.up * (Physics2D.gravity.y * (lowJumpMultiplier - 1) * Time.deltaTime);
        }
        
        
        // test for Ground:  || (rigidbody2D.velocity.y == 0 && onGround )
        if ( (onGround && !isJumping) )
        {
            isJumping = false;
            isJumpingFall = false;
            isJumpingx2 = 2;
            animator.SetBool("isJumping", false);
            animator.SetBool("isJumpingDouble", false);
            animator.SetBool("isJumpFalling", false);
        }
        
    }
    
        
    public void Jump()
    {
        isJumping = true;
        if (isJumpingx2 == 2)
        {
            animator.SetBool("isJumping", true);
        }else if (isJumpingx2 == 1)
        {
            animator.SetBool("isJumpingDouble", true);
        }
        isJumpingx2--;
        Vector2 powerFromDash = Vector2.zero; 
        rigidbody2D.velocity = Vector2.up * jumpVelocity + ( moveDirection != 0 ? Vector2.right * (jumpVelocity * moveDirection) : Vector2.zero) + powerFromDash * ( isFacingRight ? 1 : -1 );
    }
   
    
    void FlipAnimation(float dir)
    {
        if (dir > 0 && !isFacingRight || dir < 0 && isFacingRight)
        {
            isFacingRight = !isFacingRight;

            Vector2 animScale = transform.localScale;
            animScale.x *= -1;
            transform.localScale = animScale;
        }
    }
}
