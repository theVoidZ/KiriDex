using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class PlayerMovement : MonoBehaviour
{


    public float speed = 5;
    public float jumpVelocity = 8;

    
    private Rigidbody2D rigidbody2D;
    public Collider2D groundSensor;
    public LayerMask WhatIsGround;
    
    
    private float moveDirection;


    public bool onGround;
    
    void Awake()
    {
        rigidbody2D = GetComponent<Rigidbody2D>();
    }
    
    void Update()
    {
        moveDirection = 0;
        
        moveDirection = Input.GetAxisRaw("Horizontal");


    }
    
    void FixedUpdate()
    {
        onGround = Physics2D.OverlapBox((Vector2)groundSensor.transform.position + groundSensor.offset, groundSensor.bounds.extents, 0, WhatIsGround);
        
        if (Input.GetKeyDown(KeyCode.Space) )
        {
            if (onGround)
            {
                rigidbody2D.velocity = Vector2.up * jumpVelocity;                
            }


        }

        // H-Key pressed
        if (moveDirection != 0)
        {
            rigidbody2D.velocity = new Vector2( moveDirection * Time.deltaTime * speed , rigidbody2D.velocity.y);                
        }
        else
        {
            rigidbody2D.velocity = new Vector2( 0, rigidbody2D.velocity.y);
        }

        
    }

}
