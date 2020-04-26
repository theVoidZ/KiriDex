using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class VrtualGuyMovement : MonoBehaviour
{
    public float speed = 75;
    public float jumpVelocity = 6;

    public float fallMutiplier = 2.5f;
    public float lowJumpMultiplier = 1f;

    
    private float moveAxis = 6;

    private Rigidbody2D rigidbody2D;
    private Animator animator;
    private AudioManager audioManager; 
    
    public LayerMask groundLayer;
    public Collider2D groundSensor;

    private bool isFacingRight = true;
    
    public bool onGround = true;
    public bool canMove = true;
    public bool isMoving = false;

    public bool canJump = true;
    public bool isJumping = false; // up
    public bool isFalling = false; // falling
    public bool inAir = false; // both jumping up + fall
    
    
    //
    private void Awake()
    {
        rigidbody2D = GetComponent<Rigidbody2D>();
        animator = GetComponent<Animator>();
        audioManager = GetComponent<AudioManager>();
        
        animator.speed = 0.4f;

    }

    private Texture2D tex;

    // Update is called once per frame
    void Update()
    {
        moveAxis = Input.GetAxisRaw("Horizontal");
        isMoving = moveAxis != 0;
    }

    private void FixedUpdate()
    {
        onGround = Physics2D.OverlapBox((Vector2)groundSensor.transform.position + groundSensor.offset, groundSensor.bounds.extents, 0, groundLayer);

        if (onGround)
        {
            if (inAir && isFalling)
            {
                OnLand();
                inAir = false;
                isFalling = false;
                animator.SetBool("inAir", inAir );
                animator.SetBool("isFalling", isFalling );

            }

            isJumping = false;
            canJump = true;
        }
        else
        {
            if (rigidbody2D.velocity.y < 0.01f && !inAir && !isJumping && !isFalling )
            {
                // falling - from ground
                isFalling = true;
                inAir = true;
                animator.SetBool("isFalling", isFalling );
                animator.SetBool("inAir", inAir );

            }
        }

        
        // is moving ( or key pressed )
        if ( moveAxis != 0 )
        {
            FlipAnimation( moveAxis );
            rigidbody2D.velocity = new Vector2(moveAxis * speed * Time.deltaTime, rigidbody2D.velocity.y);

            if (onGround)
            {
                isMoving = Mathf.Abs(rigidbody2D.velocity.x) > float.Epsilon;
                animator.SetBool("isMoving", isMoving);
            }
        }
        else
        {
            isMoving = false;
            animator.SetBool("isMoving", isMoving);

        }


        if (Input.GetKeyDown(KeyCode.C))
        {
            if (canJump)
            {
                Jump();
            }
        }

        
        // speed alternation
        if (rigidbody2D.velocity.y < 0 )
        {
            rigidbody2D.velocity += Vector2.up * Physics2D.gravity.y * (fallMutiplier - 1) * Time.deltaTime;
        }
        else if( rigidbody2D.velocity.y > 0 && !Input.GetKey(KeyCode.C) )
        {
            rigidbody2D.velocity += Vector2.up * Physics2D.gravity.y * (lowJumpMultiplier - 1) * Time.deltaTime;
        }
        
        // reach the peak ( going up )
        if ( rigidbody2D.velocity.y <= float.Epsilon && inAir && isJumping )
        {
            Debug.Log("Interia: falling after jump");
            isJumping = false;
            isFalling = true;
            animator.SetBool("isJumping", isJumping );
            animator.SetBool("isFalling", isFalling );
        }
        


    }

    public void Jump()
    {
        isJumping = true;
        inAir = true;
        canJump = false;
        
        rigidbody2D.velocity += Vector2.up * jumpVelocity;
        
        
        animator.SetBool("isJumping", isJumping );
        animator.SetBool("inAir", inAir );

        audioManager.PlaySound("jump");
    }

    public void OnLand()
    {
        audioManager.PlaySound("jump-land");
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
